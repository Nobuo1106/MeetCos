//
//  Group+CoreDataProperties.swift
//  MeetCos
//
//  Created by apple on 2023/03/03.
//
//

import Foundation
import CoreData


extension Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var personCount: Int64
    @NSManaged public var hourlyWage: Int64
    @NSManaged public var hourlyProfit: Int64
    @NSManaged public var sessionId: Int64
}

extension Group : Identifiable {
    func saveGroup(expense: Expense) {
        let group = Group(context: PersistenceController.shared.container.viewContext)
        group.personCount = Int64(expense.personCount ?? "0") ?? 0
        group.hourlyWage = Int64(expense.hourlyWage ?? "0") ?? 0
        group.hourlyProfit = Int64(expense.hourlyProfit ?? "0") ?? 0
        group.sessionId = 1 // Replace with the appropriate session ID

        do {
            try PersistenceController.shared.container.viewContext.save()
            print("Group saved")
        } catch {
            print("Error saving group: \(error)")
        }
    }
}
