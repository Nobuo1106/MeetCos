//
//  Expense.swift
//  MeetCos
//
//  Created by apple on 2023/02/23.
//

import Foundation

struct Expense: Identifiable {
    var id = UUID()
    var personCount: Int = 0
    var hourlyWage: Int = 0
    var hourlyProfit: Int = 0
}

extension Expense {
    func toGroup(sessionId: Int64) -> Group {
        let group = Group(context: PersistenceController.shared.container.viewContext)
        group.personCount = Int64(self.personCount)
        group.hourlyWage = Int64(self.hourlyWage)
        group.hourlyProfit = Int64(self.hourlyProfit)
        group.sessionId = sessionId
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        
        let now = Date()
        group.createdAt = formatter.string(from: now)
        group.updatedAt = formatter.string(from: now)
        return group
    }
}
