//
//  File.swift
//  MeetCos
//
//  Created by apple on 2023/01/08.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var timePickerViewModel: TimePickerViewModel
    @Published var displayTime = "0:00:00"
    @Published var remainingTime: Double = 0.0
    @Published var selectedDate = Date()
    @Published var timer: AnyCancellable!
    @Published var duration: CGFloat = 1.0 // プログレスバー位置
    @Published var isTimer = true
    @Published var progressFromZerotoOne: CGFloat = 0.0
    @Published var totalCost = 0
    var latestSession: Session?
    
    init(timePickerViewModel: TimePickerViewModel) {
        self.timePickerViewModel = timePickerViewModel
        getLatestSession()
    }
    
    func getLatestSession() {
        SessionModel.shared.fetchLatestSession()
        convertFromDurationToHoursAndMinutes()
        updateDisplayTime()
    }
    
    func calcDisplayTime() -> String {
        let interval = self.selectedDate.timeIntervalSinceNow
        self.remainingTime = interval
        if self.remainingTime < 0 {
            self.isTimer = false
        }
        updateDisplayTime()
        return displayTime
    }
    
    func updateDisplayTime() {
        guard let session = SessionModel.shared.latestSession else {
            displayTime = "0:00:00"
            return
        }
        
        let duration = session.duration
        let hours = Int(duration) / 60
        let minutes = Int(duration) % 60
        let seconds = Int(duration * 60) % 60
        
        displayTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    private func formatToString () -> String{
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.unitsStyle = .positional
        dateFormatter.allowedUnits = [.hour, .minute, .second]
        dateFormatter.zeroFormattingBehavior = .dropTrailing
        self.displayTime = dateFormatter.string(from: self.remainingTime)!
        return self.displayTime
    }
    
    func start() {
        self.count()
    }
    
    func count(_ interval: Double = 0.1){
        let max = self.remainingTime
//        print("start Timer")
        // TimerPublisherが存在しているときは念の為処理をキャンセル
        if let _timer = timer{
            _timer.cancel()
        }
        
        timer = Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: ({_ in
                self.remainingTime -= 0.1
                self.displayTime = self.formatToString()
                // 切り捨て位置変更
                print(self.remainingTime)
                self.duration = 1 - CGFloat(self.remainingTime / max)
                if self.remainingTime < 0 {
                    self.stop()
                    self.duration = 1
                }
            }))
    }
    
    // タイマーの停止
    func stop(){
//        print("stop Timer")
        timer?.cancel()
        timer = nil
    }
    
    func convertFromDurationToHoursAndMinutes() {
        DispatchQueue.main.async {
            if let session = SessionModel.shared.latestSession {
                let hourMin: (hours: Int, minutes: Int) = self.timePickerViewModel.toHourAndMinutes(minutes: session.duration)
                self.timePickerViewModel.hourSelection = hourMin.hours
                self.timePickerViewModel.minSelection = hourMin.minutes
            } else {
                self.timePickerViewModel.hourSelection = 0
                self.timePickerViewModel.minSelection = 0
            }
        }
    }
    
    func saveSession() {
        SessionModel.shared.saveSession(hourSelection: timePickerViewModel.hourSelection, minSelection: timePickerViewModel.minSelection)
        updateDisplayTime()
    }
}
