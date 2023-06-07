//
//  Session+CoreDataProperties.swift
//  MeetCos
//
//  Created by apple on 2023/03/12.
//
//

import CoreData
import Foundation

public extension Session {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged var finishedAt: Date?
    @NSManaged var willFinishAt: Date?
    @NSManaged var sessionId: Int64
    @NSManaged var startedAt: Date?
    @NSManaged var createdAt: String
    @NSManaged var updatedAt: String
    @NSManaged var groups: Set<Group>
    @NSManaged var duration: Double
    @NSManaged var estimatedCost: Int64
    @NSManaged var totalCost: Int64
}

// MARK: Generated accessors for groups

public extension Session {
    @objc(addGroupsObject:)
    @NSManaged func addToGroups(_ value: Group)

    @objc(removeGroupsObject:)
    @NSManaged func removeFromGroups(_ value: Group)

    @objc(addGroups:)
    @NSManaged func addToGroups(_ values: NSSet)

    @objc(removeGroups:)
    @NSManaged func removeFromGroups(_ values: NSSet)
}

extension Session: Identifiable {}
