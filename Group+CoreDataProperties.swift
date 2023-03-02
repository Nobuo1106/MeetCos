//
//  Group+CoreDataProperties.swift
//  MeetCos
//
//  Created by apple on 2023/02/03.
//
//

import Foundation
import CoreData


extension Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var sessionId: Int64
    @NSManaged public var attendanceNum: Int64
    @NSManaged public var hourlyWage: Int64
    @NSManaged public var hourlyProfit: Int64
    @NSManaged public var session: Session?

}

extension Group : Identifiable {

}
