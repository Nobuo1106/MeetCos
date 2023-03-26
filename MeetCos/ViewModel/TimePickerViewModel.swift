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
}
