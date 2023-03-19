//
//  Utility.swift
//  MeetCos
//
//  Created by apple on 2023/03/07.
//

import Foundation

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
        formatter.minimumIntegerDigits = 1 // Add this line
        return formatter
    }()
}
