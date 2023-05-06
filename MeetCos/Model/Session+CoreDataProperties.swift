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
    
    static var latestSessionId: Int64 {
        let request: NSFetchRequest<Session> = Session.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Session.sessionId, ascending: false)]
        request.fetchLimit = 1
        do {
            let result = try PersistenceController.shared.container.viewContext.fetch(request)
            if let session = result.first {
                return session.sessionId + 1
            } else {
                return 1
            }
        } catch {
            print("Error fetching latest session id: \(error)")
            return 1
        }
    }
    
    static func getLatestSession() -> Session? {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sessionId", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "finishedAt == nil")
        fetchRequest.fetchLimit = 1
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching last session: \(error.localizedDescription)")
            return nil
        }
    }
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
