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
    //Pickerで設定した"時間"を格納する変数
    @Published var hourSelection: Int = 0
    //Pickerで設定した"分"を格納する変数
    @Published var minSelection: Int = 0
    //カウントダウン残り時間
    @Published var duration: Double = 0
    //カウントダウン開始前の最大時間
    @Published var maxValue: Double = 0
    //設定した時間が1時間以上、1時間未満1分以上、1分未満1秒以上によって変わる時間表示形式
    @Published var displayedTimeFormat: TimeFormat = .min
    
    @Published var focus: Bool = false // フォーカス
    @Published var expenses = [Expense(personCount: 0, hourlyWage: 0, hourlyProfit: 0)]
    @Published var totalCost: Int = 0
    private var groups: [Group] = []
    var latestSession: Session?
    
    init(latestSession: Session? = nil, timePickerViewModel: TimePickerViewModel) {
        self.latestSession = latestSession
        self.timePickerViewModel = timePickerViewModel
    }
    
    //カウントダウン中の残り時間を表示するためのメソッド
    func displayTimer() -> String {
        //残り時間（時間単位）= 残り合計時間（秒）/3600秒
        let hr = Int(duration) / 3600
        //残り時間（分単位）= 残り合計時間（秒）/ 3600秒 で割った余り / 60秒
        let min = Int(duration) % 3600 / 60
        //残り時間（秒単位）= 残り合計時間（秒）/ 3600秒 で割った余り / 60秒 で割った余り
        let sec = Int(duration) % 3600 % 60
        
        //setTimerメソッドの結果によって時間表示形式を条件分岐し、上の3つの定数を組み合わせて反映
        switch displayedTimeFormat {
        case .hr:
            return String(format: "%02d:%02d:%02d", hr, min, sec)
        case .min:
            return String(format: "%02d:%02d", min, sec)
        case .sec:
            return String(format: "%02d", sec)
        }
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
    
    func save() {
        let context = PersistenceController.shared.container.viewContext

        context.perform {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.timeZone = TimeZone.current
            formatter.locale = Locale.current

            let now = Date()

            if let session = self.latestSession {
                session.updatedAt = formatter.string(from: now)
                session.duration = Double(self.toTotalMinutes())

                // Remove existing groups
                session.groups.forEach { context.delete($0) }
            } else {
                let session = Session(context: context)
                session.sessionId = Session.latestSessionId
                session.createdAt = formatter.string(from: now)
                session.updatedAt = formatter.string(from: now)
                session.duration = Double(self.toTotalMinutes())
                self.latestSession = session
            }

            var groups = [Group]()

            for expense in self.expenses {
                let group = expense.toGroup(sessionId: self.latestSession?.sessionId ?? Session.latestSessionId)
                group.session = self.latestSession
                groups.append(group)
            }

            if let session = self.latestSession {
                session.groups = Set(groups)
            }

            do {
                try context.save()
                print("Session and groups saved")
            } catch {
                print("Error saving session and groups: \(error.localizedDescription)")
                context.rollback()
            }
        }
    }
    
    func returnZeroIfEmpty(_ input: Int) -> Int {
        if input == 0 {
            return 0
        }
        return input
    }
    
    private func toTotalMinutes() -> Int {
        return self.hourSelection * 60 + self.minSelection
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
            expenses = groups.map { group in
                Expense(personCount: Int(group.personCount),
                        hourlyWage: Int(group.hourlyWage),
                        hourlyProfit: Int(group.hourlyProfit)
                )
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
