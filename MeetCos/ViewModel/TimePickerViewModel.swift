//
//  TimePickerViewModel.swift
//  MeetCos
//
//  Created by apple on 2023/03/25.
//

import Foundation

class TimePickerViewModel: ObservableObject {
    @Published var hourSelection: Int = 0
    @Published var minSelection: Int = 0
    @Published var isRunning: Bool
    
    init(isRunning: Bool = false) {
        self.isRunning = isRunning
    }
    
    func toHourAndMinutes(minutes: Double) -> (hours: Int, minutes: Int) {
        let hours = Int(minutes / 60)
        let remainingMinutes = Int(minutes.truncatingRemainder(dividingBy: 60))
        return (hours: hours, minutes: remainingMinutes)
    }
    
    func updateSelectionsFromDuration(duration: Double) {
        let (hours, minutes) = toHourAndMinutes(minutes: duration)
        DispatchQueue.main.async {
            self.hourSelection = hours
            self.minSelection = minutes
        }
    }
}
