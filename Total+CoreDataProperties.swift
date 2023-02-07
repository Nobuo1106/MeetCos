//
//  Total+CoreDataProperties.swift
//  MeetCos
//
//  Created by apple on 2023/02/03.
//
//

import Foundation
import CoreData


extension Total {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Total> {
        return NSFetchRequest<Total>(entityName: "Total")
    }

    @NSManaged public var expense: Int64
    @NSManaged public var createdAt: Date?
    @NSManaged public var sessionId: Int64
    @NSManaged public var session: Session?

}

extension Total : Identifiable {

}
