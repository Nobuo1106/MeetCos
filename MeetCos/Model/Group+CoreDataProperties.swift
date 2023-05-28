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

    @NSManaged public var orderIndex: Int16
    @NSManaged public var hourlyProfit: Int64
    @NSManaged public var hourlyWage: Int64
    @NSManaged public var personCount: Int64
    @NSManaged public var sessionId: Int64
    @NSManaged public var createdAt: String
    @NSManaged public var updatedAt: String
    @NSManaged public var session: Session?

}

extension Group : Identifiable {
}
