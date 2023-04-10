//
//  CountDownTimerViewModel.swift
//  MeetCos
//
//  Created by apple on 2023/04/09.
//

import Foundation
import Combine

class CountdownTimerViewModel: ObservableObject {
    @Published var remainingTime: Double = 0.0
    @Published var timer: AnyCancellable!
    // ... other timer-related properties

    // ... timer-related functions
    func start() {
        // ...
    }

    func stop() {
        // ...
    }

    // ... other timer-related functions
}
