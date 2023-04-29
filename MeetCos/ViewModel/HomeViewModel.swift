//
//  File.swift
//  MeetCos
//
//  Created by apple on 2023/01/08.
//

import Foundation
import Combine
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var timePickerViewModel: TimePickerViewModel
    @Published var countdownTimerViewModel: CountdownTimerViewModel
    @Published var isRunning = false
    @Published var totalCost = 0
    var latestSession: Session?
    private var appInBackground = false
    private var backgroundTime: Date?
    private let sharedData = SharedData()
    private var timePickerSelectionsObserver: AnyCancellable?
    private var cancellables: Set<AnyCancellable> = []
    
    init(timePickerViewModel: TimePickerViewModel) {
        let groups: [Group] = []
        self.timePickerViewModel = timePickerViewModel
        let initialDuration = Double(timePickerViewModel.hourSelection * 3600 + timePickerViewModel.minSelection * 60)
        let tempCountdownTimerViewModel = CountdownTimerViewModel(initialDuration: initialDuration, groups: groups)
        self.countdownTimerViewModel = tempCountdownTimerViewModel
        
        getLatestSession { [weak self] in
            guard let self = self else { return }
            self.updateDisplayTime()
            self.updateCountdownTimerViewModel()
        }
        
        timePickerViewModel.$hourSelection
            .combineLatest(timePickerViewModel.$minSelection)
            .sink { [weak self] (_, _) in
                self?.updateSessionDuration()
            }
            .store(in: &cancellables)
    }
    
    func appStateChanged(_ scenePhase: ScenePhase) {
        switch scenePhase {
        case .background:
            //            appDidEnterBackground()
            break
        case .active:
            //            appWillEnterForeground()
            break
        default:
            break
        }
    }
    
    //    func appDidEnterBackground() {
    //        appInBackground = true
    //        backgroundTime = Date()
    //    }
    
    //    func appWillEnterForeground() {
    //        if appInBackground, let backgroundTime = backgroundTime {
    //            let timeInBackground = Date().timeIntervalSince(backgroundTime)
    //            remainingTime -= timeInBackground
    //        }
    //        appInBackground = false
    //    }
    
    func getLatestSession(completion: @escaping () -> Void) {
        SessionModel.shared.fetchLatestSession()
        DispatchQueue.main.async {
            self.convertFromDurationToHoursAndMinutes()
            completion()
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
    func stop(){
        isRunning = false
        countdownTimerViewModel.stop()
    }
    
    func reset() {
        isRunning = false
        countdownTimerViewModel.reset()
    }
    
    func convertFromDurationToHoursAndMinutes() {
        if let session = SessionModel.shared.latestSession {
            let hourMin: (hours: Int, minutes: Int) = self.timePickerViewModel.toHourAndMinutes(minutes: session.duration)
            self.timePickerViewModel.hourSelection = hourMin.hours
            self.timePickerViewModel.minSelection = hourMin.minutes
        } else {
            self.timePickerViewModel.hourSelection = 0
            self.timePickerViewModel.minSelection = 0
        }
    }
    
    func saveSession() {
        SessionModel.shared.saveSession(hourSelection: timePickerViewModel.hourSelection, minSelection: timePickerViewModel.minSelection)
        updateDisplayTime()
    }
    
    func updateCountdownTimer() {
        let newDuration = Double(timePickerViewModel.hourSelection * 3600 + timePickerViewModel.minSelection * 60)
        countdownTimerViewModel.remainingTime = newDuration
    }
    
    func updateSessionDuration() {
        let newHour = timePickerViewModel.hourSelection
        let newMinute = timePickerViewModel.minSelection
        SessionModel.shared.upsertSession(session: SessionModel.shared.latestSession, hour: newHour, minute: newMinute) { [weak self] updatedSession in
            guard let self = self else { return }
            SessionModel.shared.latestSession = updatedSession
            self.updateCountdownTimerViewModel()
        }
    }
    
    func updateCountdownTimerViewModel() {
        guard let session = SessionModel.shared.latestSession else { return }
        let newDuration = session.duration
        let groups = Array(session.groups)
        countdownTimerViewModel.updateDuration(newDuration: newDuration)
        countdownTimerViewModel.initializeTotalCost(groups: groups)
    }
    
    func finishSession() {
        if let latestSession = SessionModel.shared.latestSession {
            SessionModel.shared.updateFinishedAt(for: latestSession)
        }

        timePickerViewModel.hourSelection = 0
        timePickerViewModel.minSelection = 0

        if !SessionModel.shared.isEmptySession(SessionModel.shared.latestSession) {
            SessionModel.shared.createEmptySession {
                self.updateCountdownTimerViewModel()
            }
        }
    }
}
