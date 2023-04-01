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
    
    func toHourAndMinutes(minutes: Double) -> (hours: Int, minutes: Int) {
        let hours = Int(minutes / 60)
        let remainingMinutes = Int(minutes.truncatingRemainder(dividingBy: 60))
        return (hours: hours, minutes: remainingMinutes)
    }
}
