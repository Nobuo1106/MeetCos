//
//  Session+CoreDataProperties.swift
//  MeetCos
//
//  Created by apple on 2023/03/05.
//
//

import Foundation
import CoreData


extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var sessionId: Date?
    @NSManaged public var startedAt: Date?
    @NSManaged public var finishedAt: Date?
    @NSManaged public var groups: Group?

}

extension Session : Identifiable {

}
