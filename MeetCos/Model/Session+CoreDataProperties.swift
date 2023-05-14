//
//  Session+CoreDataProperties.swift
//  MeetCos
//
//  Created by apple on 2023/03/12.
//
//

import Foundation
import CoreData


extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var finishedAt: Date?
    @NSManaged public var willFinishAt: Date?
    @NSManaged public var sessionId: Int64
    @NSManaged public var startedAt: Date?
    @NSManaged public var createdAt: String
    @NSManaged public var updatedAt: String
    @NSManaged public var groups: Set<Group>
    @NSManaged public var duration: Double
    @NSManaged public var estimatedCost: Int64
    @NSManaged public var totalCost: Int64
}

// MARK: Generated accessors for groups
extension Session {

    @objc(addGroupsObject:)
    @NSManaged public func addToGroups(_ value: Group)

    @objc(removeGroupsObject:)
    @NSManaged public func removeFromGroups(_ value: Group)

    @objc(addGroups:)
    @NSManaged public func addToGroups(_ values: NSSet)

    @objc(removeGroups:)
    @NSManaged public func removeFromGroups(_ values: NSSet)

}

extension Session : Identifiable {

}
