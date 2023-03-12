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
    @NSManaged public var session: Session?
}

extension Group {
    func saveGroup(sessionId: Int64) {
        let group = Group(context: PersistenceController.shared.container.viewContext)
        group.personCount = self.personCount
        group.hourlyWage = self.hourlyWage
        group.hourlyProfit = self.hourlyProfit
        group.sessionId = sessionId
        
        do {
            try PersistenceController.shared.container.viewContext.save()
            print("Group saved")
        } catch {
            print("Error saving group: \(error.localizedDescription)")
            PersistenceController.shared.container.viewContext.rollback()
        }
    }
}
