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

    @NSManaged public var sessionId: Int64
    @NSManaged public var startedAt: Date?
    @NSManaged public var finishedAt: Date?
//    @NSManaged public var groups: Group?
    @NSManaged public var groups: Set<Group>
    
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
    
    func saveSession(groups: [Group]) {
        self.groups = Set(self.groups).union(groups)
        self.sessionId = Int64(Session.latestSessionId)
        
        do {
            try PersistenceController.shared.container.viewContext.save()
            print("Session saved")
        } catch {
            print("Error saving session: \(error)")
            PersistenceController.shared.container.viewContext.rollback()
        }
    }
}

extension Session : Identifiable {

}
