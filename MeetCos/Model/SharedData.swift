//
//  SharedData.swift
//  MeetCos
//
//  Created by apple on 2023/04/09.
//

import Foundation

class SharedData {
    private let userDefaults = UserDefaults.standard

    var remainingTime: Double {
        get {
            return userDefaults.double(forKey: "remainingTime")
        }
        set {
            userDefaults.set(newValue, forKey: "remainingTime")
            userDefaults.synchronize()
        }
    }
}
