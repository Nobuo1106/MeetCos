//
//  Session+CoreDataProperties.swift
//  MeetCos
//
//  Created by apple on 2023/02/03.
//
//

import Foundation
import CoreData


extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var startedAt: Date?
    @NSManaged public var willFinishAt: Date?
    @NSManaged public var group: NSSet?
    @NSManaged public var total: Total?

}

// MARK: Generated accessors for group
extension Session {

    @objc(addGroupObject:)
    @NSManaged public func addToGroup(_ value: Group)

    @objc(removeGroupObject:)
    @NSManaged public func removeFromGroup(_ value: Group)

    @objc(addGroup:)
    @NSManaged public func addToGroup(_ values: NSSet)

    @objc(removeGroup:)
    @NSManaged public func removeFromGroup(_ values: NSSet)

}

extension Session : Identifiable {

}
