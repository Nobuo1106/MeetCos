//
//  HomeViewModel.swift
//  MeetCos
//
//  Created by apple on 2023/01/08.
//

import Combine
import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var timePickerViewModel: TimePickerViewModel
    @Published var countdownTimerViewModel: CountdownTimerViewModel
    @Published var isRunning = false
    @Published var estimatedTotalCost = 0
    private var appInBackground = false
    private var backgroundTime: Date?
    private let sharedData = SharedData()
    private var timePickerSelectionsObserver: AnyCancellable?
    private var cancellables: Set<AnyCancellable> = []

    init(timePickerViewModel: TimePickerViewModel, countdownTimerViewModel: CountdownTimerViewModel) {
        let groups: [Group] = []
        self.timePickerViewModel = timePickerViewModel
        self.countdownTimerViewModel = countdownTimerViewModel
        let initialDuration = Double(timePickerViewModel.hourSelection * 3600 + timePickerViewModel.minSelection * 60)
        let tempCountdownTimerViewModel = CountdownTimerViewModel(initialDuration: initialDuration, groups: groups)
        self.countdownTimerViewModel = tempCountdownTimerViewModel

        getLatestSession { [weak self] session in
            guard let self = self else {
                return
            }
            SessionModel.shared.latestSession = session
            self.updateEstimatedTotalCost()
            self.updateDisplayTime()
            self.updateCountdownTimerViewModel()
        }

        timePickerViewModel.$hourSelection
            .combineLatest(timePickerViewModel.$minSelection)
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main) // 重複Insertを防ぐためにdebounceを利用
            .sink { [weak self] _, _ in
                self?.updateSessionDuration()
            }
            .store(in: &cancellables)
    }

    func appStateChanged(_ scenePhase: ScenePhase) {
        switch scenePhase {
        case .background:
            if isRunning {
                countdownTimerViewModel.appMovedToBackground()
            }
        case .active:
            if isRunning {
                countdownTimerViewModel.appMovedToForeground()
            }
        default:
            break
        }
    }

    func getLatestSession(completion: @escaping (Session?) -> Void) {
        SessionModel.shared.fetchLatestSession { [weak self] latestSession in
            guard let self = self else {
                return
            }
            self.convertFromDurationToHoursAndMinutes()
            completion(latestSession)
        }
    }

    func updateDisplayTime() {
        guard let session = SessionModel.shared.latestSession else {
            return
        }
        let duration = session.duration
        timePickerViewModel.updateSelectionsFromDuration(duration: duration)
    }

    func start() {
        isRunning = true
        if let session = SessionModel.shared.latestSession {
            if session.startedAt == nil {
                SessionModel.shared.updateStartedAt(for: session)
            }
        }
        countdownTimerViewModel.start()
    }

    // タイマーの停止
    func stop() {
        isRunning = false
        countdownTimerViewModel.stop()
    }

    func reset() {
        isRunning = false
        countdownTimerViewModel.reset()
    }

    func convertFromDurationToHoursAndMinutes() {
        if let session = SessionModel.shared.latestSession {
            let hourMin: (hours: Int, minutes: Int) = timePickerViewModel.toHourAndMinutes(minutes: session.duration)
            timePickerViewModel.hourSelection = hourMin.hours
            timePickerViewModel.minSelection = hourMin.minutes
        } else {
            timePickerViewModel.hourSelection = 0
            timePickerViewModel.minSelection = 0
        }
    }

    func updateCountdownTimer() {
        let newDuration = Double(timePickerViewModel.hourSelection * 3600 + timePickerViewModel.minSelection * 60)
        countdownTimerViewModel.remainingTime = newDuration
    }

    func updateSessionDuration() {
        let newHour = timePickerViewModel.hourSelection
        let newMinute = timePickerViewModel.minSelection

        SessionModel.shared.fetchLatestSession { [weak self] latestSession in
            guard let self = self else {
                return
            }
            SessionModel.shared.latestSession = latestSession
            let totalCost = self.calculateEstimatedTotalCost(session: SessionModel.shared.latestSession)
            SessionModel.shared.upsertSession(session: SessionModel.shared.latestSession, hour: newHour, minute: newMinute, estimatedCost: totalCost) { updatedSession in
                SessionModel.shared.latestSession = updatedSession
                self.updateEstimatedTotalCost()
                self.updateCountdownTimerViewModel()
            }
        }
    }

    func updateCountdownTimerViewModel() {
        guard let session = SessionModel.shared.latestSession else {
            return
        }
        let newDuration = session.duration
        let groups = Array(session.groups)
        countdownTimerViewModel.updateDuration(newDuration: newDuration)
        countdownTimerViewModel.initializeTotalCost(groups: groups)
    }

    func finishSession(completion: @escaping () -> Void) {
        if let latestSession = SessionModel.shared.latestSession {
            let totalCost = Int(countdownTimerViewModel.totalCost)
            SessionModel.shared.updateSessionEndDetails(for: latestSession, totalCost: totalCost)
        }

        if !SessionModel.shared.isEmptySession(SessionModel.shared.latestSession) {
            SessionModel.shared.createEmptySession {
                self.updateCountdownTimerViewModel()
                self.timePickerViewModel.hourSelection = 0
                self.timePickerViewModel.minSelection = 0
                self.updateEstimatedTotalCost()
                completion()
            }
        } else {
            completion()
        }
    }

    func calculateEstimatedTotalCost(session: Session?) -> Int {
        let totalMinutes = Decimal(toTotalMinutes())
        guard let groups = session?.groups else {
            return 0 // グループが存在しないときはコストは0円
        }
        let totalDecimal: Decimal = groups.reduce(Decimal.zero) { result, group in
            let personCount = Decimal(group.personCount)
            let hourlyWage = Decimal(group.hourlyWage)
            let hourlyProfit = Decimal(group.hourlyProfit)
            let subtotal = (personCount * (hourlyWage + hourlyProfit)) * totalMinutes / 60
            return result + (subtotal.isNaN ? Decimal.zero : subtotal)
        }
        let handler = NSDecimalNumberHandler(roundingMode: .bankers, scale: 0, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let totalInt: Int = NSDecimalNumber(decimal: totalDecimal).rounding(accordingToBehavior: handler).intValue
        return totalInt
    }

    private func toTotalMinutes() -> Int {
        let utility = Utility()
        return utility.toTotalMinutes(hours: timePickerViewModel.hourSelection, minutes: timePickerViewModel.minSelection)
    }

    func updateEstimatedTotalCost() {
        estimatedTotalCost = Int(SessionModel.shared.latestSession?.estimatedCost ?? 0)
    }
}
