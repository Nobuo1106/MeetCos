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
        fetchLatestSession()
    }
    
    func fetchLatestSession() {
        self.latestSession = Session.getLatestSession()
    }
    
    /// SheetViewModel、HomeViewModelで利用する為、expense引数がなくても使える。
    /// 柔軟にする為直近のSessionオブジェクトも変更出来るように実装。
    /// latestSessionのデータ一貫性の為Sessionを返す。
    func upsertSession(session: Session?, hour: Int, minute: Int, expenses: [Expense] = [], completion: @escaping (Session?) -> Void) {
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
                targetSession.sessionId = Session.latestSessionId
                targetSession.createdAt = formatter.string(from: now)
            }
            
            targetSession.updatedAt = formatter.string(from: now)
            targetSession.duration = Double(hour * 60 + minute)
            
            if !expenses.isEmpty {
                // Remove existing groups
                targetSession.groups.forEach { context.delete($0) }
                
                var groups = [Group]()
                
                for expense in expenses {
                    let group = expense.toGroup(sessionId: targetSession.sessionId)
                    group.session = targetSession
                    groups.append(group)
                }
                targetSession.groups = Set(groups)
            }
            
            do {
                try context.save()
                print("Session and groups saved")
                completion(targetSession)
            } catch {
                print("Error saving session and groups: \(error.localizedDescription)")
                context.rollback()
                completion(nil)
            }
        }
    }
    
    func saveSession(hourSelection: Int, minSelection: Int) {
        guard let latestSession = self.latestSession else { return }
        
        let newDuration = Double(hourSelection * 60 + minSelection)
        if latestSession.duration != newDuration {
            latestSession.duration = newDuration
            
            let context = PersistenceController.shared.container.viewContext
            do {
                try context.save()
                print("Session duration updated")
            } catch {
                print("Error updating session duration: \(error.localizedDescription)")
                context.rollback()
            }
        }
    }
}
