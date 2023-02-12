//
//  SheetViewModel.swift
//  MeetCos
//
//  Created by apple on 2023/01/17.
//

import Foundation

struct Expense: Identifiable {
    var id = UUID()
    var personNum: Int?
    var laborCosts: Int?
    var estimatedSales: Int?
}

class Expenses: ObservableObject {
    @Published var expenses:[Expense] = [Expense(personNum: 0, laborCosts: 0, estimatedSales: 0)]
}

enum CountWay : String{
    case personNum
    case yen
}

class SheetViewModel: ObservableObject {
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
    
    func calculateSession() {
        
    }
    
    func save() {
        let session = calculateSession()
        // CoreData save
        // coredata.session.save()
        // coredata.group.save()
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

