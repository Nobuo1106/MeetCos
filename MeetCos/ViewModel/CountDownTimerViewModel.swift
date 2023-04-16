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
    @Published var timer: AnyCancellable!
    @Published var progress: CGFloat = 0.0
    @Published var displayTime: String = "0:00:00"
    private let interval: Double = 0.1
    
    init(initialDuration: Double) {
        self.remainingTime = initialDuration
        self.initialDuration = initialDuration
    }

    func start(duration: Double) {
        self.remainingTime = duration
        
        timer = Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                self.remainingTime -= self.interval
                
                if self.remainingTime <= 0 {
                    self.stop()
                }
            }
    }

    func stop() {
        timer?.cancel()
        timer = nil
    }
    
    func updateDuration(newDuration: Double) {
        self.initialDuration = newDuration
        self.remainingTime = newDuration
    }
    
    var formattedRemainingTime: String {
        let hours = Int(remainingTime) / 60
        let minutes = (Int(remainingTime) % 60)
        let seconds = Int(remainingTime * 60) % 60

        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
