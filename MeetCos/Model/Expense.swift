//
//  Expense.swift
//  MeetCos
//
//  Created by apple on 2023/02/23.
//

import Foundation

struct Expense: Identifiable {
    var id = UUID()
    var personCount: String?
    var hourlyWage: String?
    var hourlyProfit: String?
}


extension Expense {
    func toGroup(sessionId: Int64) -> Group {
        let group = Group(context: PersistenceController.shared.container.viewContext)
        group.personCount = Int64(self.personCount ?? "0") ?? 0
        group.hourlyWage = Int64(self.hourlyWage ?? "0") ?? 0
        group.hourlyProfit = Int64(self.hourlyProfit ?? "0") ?? 0
        group.sessionId = sessionId
        return group
    }
}
