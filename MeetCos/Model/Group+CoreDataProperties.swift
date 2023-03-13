//
//  Group+CoreDataProperties.swift
//  MeetCos
//
//  Created by apple on 2023/03/12.
//
//

import Foundation
import CoreData


extension Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var hourlyProfit: Int64
    @NSManaged public var hourlyWage: Int64
    @NSManaged public var personCount: Int64
    @NSManaged public var sessionId: Int64
    @NSManaged public var createdAt: String
    @NSManaged public var updatedAt: String
    @NSManaged public var session: Session?

}

extension Group : Identifiable {
    func saveGroup(sessionId: Int64) {
        let group = Group(context: PersistenceController.shared.container.viewContext)
        group.personCount = self.personCount
        group.hourlyWage = self.hourlyWage
        group.hourlyProfit = self.hourlyProfit
        group.sessionId = sessionId
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        let now = Date()
        createdAt = formatter.string(from: now)
        updatedAt = formatter.string(from: now)
        
        do {
            try PersistenceController.shared.container.viewContext.save()
            print("Group saved")
        } catch {
            print("Error saving group: \(error.localizedDescription)")
            PersistenceController.shared.container.viewContext.rollback()
        }
    }
}
