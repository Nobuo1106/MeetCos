//
//  SheetViewModel.swift
//  MeetCos
//
//  Created by apple on 2023/01/17.
//

import Foundation

enum CountWay : String{
    case personNum
    case yen
}

class SheetViewModel {
    private func whichCount(unit: CountWay) -> String {
        switch unit {
        case .personNum:
            return "人"
        case .yen:
            return "円"
        }
    }
    
    func ConvertFromIntToPersonNum(num: Int, unit: CountWay) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        return formatter.string(from: NSNumber(value: num)) ?? "0" + whichCount(unit: unit)
    }
}
