//
//  Utility.swift
//  MeetCos
//
//  Created by apple on 2023/03/07.
//

import Foundation

class Utility {
    func toTotalMinutes(hours: Int, minutes: Int) -> Int {
        return hours * 60 + minutes
    }
    
    static func formatToYen(_ value: Int) -> String {
        return "¥\(value)"
    }
    // ResultViewに表示する時間を経過時間に応じて整形
    static func timeString(from seconds: Int?) -> String {
        guard let seconds = seconds else { return "N/A" }
        
        if seconds < 60 {
            return "\(seconds) 秒"
        }
        
        let minutes = seconds / 60
        
        if minutes < 60 {
            return "\(minutes) 分"
        }
        
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        
        return "\(hours) 時間 \(remainingMinutes) 分"
    }
    
    static func formatDate(date: Date?, format: String = "yyyy.M.d HH:mm") -> String {
        guard let date = date else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}

extension String {
    var isLessThanSix: Bool {
        return self.count <= 6
    }
    
    var isLessThanEight: Bool {
        return self.count <= 8
    }
    
    var isNumeric: Bool {
        return self.range(of: "[^.0-9]", options: .regularExpression) == nil && self != ""
    }
}

class NumberFormatterUtility {
    static let shared = NumberFormatterUtility()

    let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumIntegerDigits = 1
        return formatter
    }()
}
