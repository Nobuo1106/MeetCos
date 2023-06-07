//
//  Group+CoreDataProperties.swift
//  MeetCos
//
//  Created by apple on 2023/03/12.
//
//

import CoreData
import Foundation

public extension Group {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged var orderIndex: Int16
    @NSManaged var hourlyProfit: Int64
    @NSManaged var hourlyWage: Int64
    @NSManaged var personCount: Int64
    @NSManaged var sessionId: Int64
    @NSManaged var createdAt: String
    @NSManaged var updatedAt: String
    @NSManaged var session: Session?
}

extension Group: Identifiable {}
