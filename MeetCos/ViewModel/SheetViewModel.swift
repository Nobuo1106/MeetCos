//
//  SheetViewModel.swift
//  MeetCos
//
//  Created by apple on 2023/01/17.
//

import Foundation
import SwiftUI
import CoreData
import Combine

enum TimeFormat {
    case hr
    case min
    case sec
}

class SheetViewModel: ObservableObject {
    @Published var timePickerViewModel: TimePickerViewModel
    private var cancellables: Set<AnyCancellable> = []
    //カウントダウン残り時間
    @Published var duration: Double = 0
    //カウントダウン開始前の最大時間
    @Published var maxValue: Double = 0
    //設定した時間が1時間以上、1時間未満1分以上、1分未満1秒以上によって変わる時間表示形式
    @Published var displayedTimeFormat: TimeFormat = .min
    
    @Published var focus: Bool = false // フォーカス
    @Published var expenses = [Expense(personCount: 0, hourlyWage: 0, hourlyProfit: 0)]
    @Published var totalCost: Int = 0
    var latestSession: Session?
    
    init(latestSession: Session? = nil, timePickerViewModel: TimePickerViewModel) {
        self.latestSession = latestSession
        self.timePickerViewModel = timePickerViewModel
    }
    
    func calculateSession() -> Int {
        let totalMinutes: Decimal = Decimal(toTotalMinutes())
        let totalDecimal: Decimal = expenses.reduce(Decimal.zero) { (result, expense) in
            let personCount = Decimal(expense.personCount)
            let hourlyWage = Decimal(expense.hourlyWage)
            let hourlyProfit = Decimal(expense.hourlyProfit)
            let subtotal = (personCount * hourlyWage + hourlyProfit) * totalMinutes / 60
            return result + (subtotal.isNaN ? Decimal.zero : subtotal)
        }
        let handler = NSDecimalNumberHandler(roundingMode: .bankers, scale: 0, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let totalInt: Int = NSDecimalNumber(decimal: totalDecimal).rounding(accordingToBehavior: handler).intValue
        return totalInt
    }
    
    func changeTotal() {
        totalCost = calculateSession()
    }
    
    func saveSessionAndGroups() {
        let hour = timePickerViewModel.hourSelection
        let minute = timePickerViewModel.minSelection
        SessionModel.shared.upsertSession(session: latestSession, hour: hour, minute: minute, expenses: expenses) { updatedSession in
            if let updatedSession = updatedSession {
                self.latestSession = updatedSession
            }
        }
        self.changeTotal()
    }
    
    private func toTotalMinutes() -> Int {
        return timePickerViewModel.hourSelection * 60 + timePickerViewModel.minSelection
    }
    
    func hourlyWage(for expense: Expense) -> Binding<Int> {
        Binding(
            get: {
                expense.hourlyWage
            },
            set: { [self] newValue in
                if let index = self.expenses.firstIndex(where: { $0.id == expense.id }) {
                    expenses[index].hourlyWage = newValue
                }
            }
        )
    }
    
    func personCount(for expense: Expense) -> Binding<Int> {
        Binding(
            get: {
                expense.personCount
            },
            set: { [self] newValue in
                if let index = self.expenses.firstIndex(where: { $0.id == expense.id }) {
                    expenses[index].personCount = newValue
                }
            }
        )
    }
    
    func hourlyProfit(for expense: Expense) -> Binding<Int> {
        Binding(
            get: {
                expense.hourlyProfit
            },
            set: { [self] newValue in
                if let index = self.expenses.firstIndex(where: { $0.id == expense.id }) {
                    expenses[index].hourlyProfit = newValue
                }
            }
        )
    }
    
    func getLatestGroups(from session: Session? = nil) {
        let targetSession = session ?? getLatestSession()
        if let latestSession = targetSession {
            let hourMin: (hours: Int, minutes: Int) = timePickerViewModel.toHourAndMinutes(minutes: latestSession.duration)
            timePickerViewModel.hourSelection = hourMin.hours
            timePickerViewModel.minSelection = hourMin.minutes
            let groups = Array(latestSession.groups)
            if groups.isEmpty {
                expenses = [Expense(personCount: 0, hourlyWage: 0, hourlyProfit: 0)]
            } else {
                expenses = groups.map { group in
                    Expense(personCount: Int(group.personCount),
                            hourlyWage: Int(group.hourlyWage),
                            hourlyProfit: Int(group.hourlyProfit)
                    )
                }
            }
        } else {
            expenses = [Expense(personCount: 0, hourlyWage: 0, hourlyProfit: 0)]
        }
        self.changeTotal()
    }
    
    private func getLatestSession() -> Session? {
        let session = Session.getLatestSession()
        self.latestSession = session
        return session
    }
}
