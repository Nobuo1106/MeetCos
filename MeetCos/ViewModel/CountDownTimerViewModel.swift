//
//  CountDownTimerViewModel.swift
//  MeetCos
//
//  Created by apple on 2023/04/09.
//

import Foundation
import Combine

class CountdownTimerViewModel: ObservableObject {
    @Published var initialDuration: Double
    @Published var remainingTime: Double
//    private var remainingTimeInSeconds: Double
    @Published var displayTime: String = "0:00:00"
    private var timer: Timer?
    
    init(initialDuration: Double) {
        self.remainingTime = initialDuration
        self.initialDuration = initialDuration
//        self.remainingTimeInSeconds = initialDuration * 60
    }
    
    func start() {
        stop() // Ensure any existing timer is stopped before starting a new one

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                self.stop()
            }
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateDuration(newDuration: Double) {
        self.initialDuration = newDuration * 60
        self.remainingTime = newDuration * 60
    }
    
    var formattedRemainingTime: String {
        let hours = Int(remainingTime) / 3600
        let minutes = (Int(remainingTime) % 3600) / 60
        let seconds = Int(remainingTime) % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
