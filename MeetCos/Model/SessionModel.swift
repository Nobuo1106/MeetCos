//
//  Session.swift
//  MeetCos
//
//  Created by apple on 2023/04/01.
//

import Foundation
import CoreData

class SessionModel {
    static let shared = SessionModel()
    var latestSession: Session?
    
    private init() {
        fetchLatestSession { latestSession in
            self.latestSession = latestSession
        }
    }
    
    func fetchLatestSession(completion: @escaping (Session?) -> Void) {
        let request: NSFetchRequest<Session> = Session.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        request.fetchLimit = 1
        
        do {
            let sessions = try PersistenceController.shared.container.viewContext.fetch(request)
            if let session = sessions.first {
                completion(session)
            } else {
                completion(nil)
            }
        } catch {
            print("Error fetching latest session: \(error.localizedDescription)")
            completion(nil)
        }
    }
    
    // ResultViewで終了したセッションを取得する
    func fetchLatestFinishedSession(completion: @escaping (Session?) -> Void) {
        let context = PersistenceController.shared.container.viewContext
        
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "finishedAt > %@", NSDate.distantPast as CVarArg)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        context.perform {
            do {
                let sessions = try context.fetch(fetchRequest)
                completion(sessions.first)
            } catch {
                print("Error fetching latest finished session: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    /// SheetViewModel、HomeViewModelで利用する為、expense引数がなくても使える。
    /// latestSessionのデータ一貫性の為Sessionを返す。
    func upsertSession(session: Session?, hour: Int, minute: Int, totalCost: Int? = nil, estimatedCost: Int = 0, expenses: [Expense] = [], completion: @escaping (Session?) -> Void) {
        let context = PersistenceController.shared.container.viewContext
        
        context.perform {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.timeZone = TimeZone.current
            formatter.locale = Locale.current
            
            let now = Date()
            
            let targetSession: Session
            if let existingSession = session {
                targetSession = existingSession
            } else {
                targetSession = Session(context: context)
                targetSession.sessionId = self.getNextSessionId()
                targetSession.createdAt = formatter.string(from: now)
            }
            
            targetSession.updatedAt = formatter.string(from: now)
            targetSession.duration = Double(hour * 60 + minute)
            if let totalCost = totalCost {
                targetSession.totalCost = Int64(totalCost)
            }
            targetSession.estimatedCost = Int64(estimatedCost)
            
            if !expenses.isEmpty {
                targetSession.groups.forEach { context.delete($0) }
                var groups = [Group]()
                for (index, expense) in expenses.enumerated() {
                    let group = expense.toGroup(sessionId: targetSession.sessionId)
                    group.session = targetSession
                    group.orderIndex = Int16(index)
                    groups.append(group)
                }
                targetSession.groups = Set(groups)
            }
            
            do {
                try context.save()
                completion(targetSession)
            } catch {
                print("Error saving session and groups: \(error.localizedDescription)")
                context.rollback()
                completion(nil)
            }
        }
    }
    
    func updateStartedAt(for session: Session) {
        let context = PersistenceController.shared.container.viewContext
        context.perform {
            let now = Date()
            session.startedAt = now
            
            do {
                try context.save()
            } catch {
                print("Error updating session startedAt: \(error.localizedDescription)")
                context.rollback()
            }
        }
    }
    
    func updateSessionEndDetails(for session: Session, totalCost: Int) {
        let context = PersistenceController.shared.container.viewContext
        context.perform {
            let now = Date()
            session.finishedAt = now
            session.totalCost = Int64(totalCost)
            
            do {
                try context.save()
            } catch {
                print("Error updating session startedAt: \(error.localizedDescription)")
                context.rollback()
            }
        }
    }
    
    func resetLatestSession() {
        latestSession = nil
    }
    
    func createEmptySession(completion: @escaping () -> Void) {
        let context = PersistenceController.shared.container.viewContext
        context.perform {
            let session = Session(context: context)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.timeZone = TimeZone.current
            formatter.locale = Locale.current
            let now = Date()
            session.createdAt = formatter.string(from: now)
            session.updatedAt = formatter.string(from: now)
            
            session.finishedAt = nil
            session.duration = 0
            if let latestSession = self.latestSession {
                session.sessionId = latestSession.sessionId + 1
            } else {
                session.sessionId = 1
            }
            
            do {
                try context.save()
                DispatchQueue.main.async {
                    self.latestSession = nil
                    completion()
                }
            } catch {
                print("Error creating empty session: \(error.localizedDescription)")
                context.rollback()
            }
        }
    }
    
    func isEmptySession(_ session: Session?) -> Bool {
        guard let session = session else { return true }
        return session.startedAt == nil && session.finishedAt == nil && session.duration == 0
    }
    
    func getNextSessionId() -> Int64 {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Session")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sessionId", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        let context = PersistenceController.shared.container.viewContext
        do {
            let results = try context.fetch(fetchRequest) as? [Session]
            if let lastSession = results?.first {
                return lastSession.sessionId + 1
            } else {
                return 1
            }
        } catch {
            print("Error fetching last session ID: \(error.localizedDescription)")
            return 1
        }
    }
    
    func fetchCompletedSessions(completion: @escaping ([Session]) -> Void) {
        let context = PersistenceController.shared.container.viewContext
        let request: NSFetchRequest<Session> = Session.fetchRequest()
        request.predicate = NSPredicate(format: "finishedAt != nil")
        
        do {
            let completedSessions = try context.fetch(request)
            completion(completedSessions)
        } catch {
            print("Error fetching completed sessions: \(error.localizedDescription)")
            completion([])
        }
    }
}

extension Session {
    static var sampleSession: Session {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let sampleSession = Session(context: context)
        sampleSession.finishedAt = Date()
        sampleSession.willFinishAt = Date().addingTimeInterval(60 * 60)
        sampleSession.sessionId = 1
        sampleSession.startedAt = Date().addingTimeInterval(-60 * 60)
        sampleSession.createdAt = "2023-05-07"
        sampleSession.updatedAt = "2023-05-07"
        sampleSession.duration = 3600
        sampleSession.estimatedCost = 1000
        sampleSession.totalCost = 1200
        
        let sampleGroup = Group(context: context)
        sampleGroup.hourlyProfit = 100
        sampleGroup.hourlyWage = 1000
        sampleGroup.personCount = 1
        
        sampleSession.addToGroups(sampleGroup)
        
        return sampleSession
    }
}
