//
//  ResultViewModel.swift
//  MeetCos
//
//  Created by apple on 2023/05/03.
//

import Foundation
import SwiftUI

class ResultViewModel: ObservableObject {
    @Published var latestFinishedSession: Session?
    @Published var totalSeconds: Int?
    @Published var estimatedSeconds: Int?
    @Published var estimatedCost: Int?
    @Published var totalCost: Int?
    
    init() {
        fetchLatestFinishedSession()
    }

    func fetchLatestFinishedSession() {
        SessionModel.shared.fetchLatestFinishedSession { session in
            guard let latestFinishedSession = session else {
                print("latestFinishedSession fetch失敗")
                return
            }
            self.updatePublishedProperties(using: latestFinishedSession)
        }
    }
    
    // 最新の終了後セッションから合計時間、予定時間、コスト、予定コストを計算
    private func updatePublishedProperties(using latestFinishedSession: Session) {
        self.latestFinishedSession = latestFinishedSession
        
        if let startedAt = latestFinishedSession.startedAt,
           let finishedAt = latestFinishedSession.finishedAt {
            
            let interval = finishedAt.timeIntervalSince(startedAt)
            print(interval)
            self.totalSeconds = Int(interval)
        } else {
            self.totalSeconds = 0
        }
        self.totalCost = Int(latestFinishedSession.totalCost)
        self.estimatedSeconds = Int(latestFinishedSession.duration) * 60
        self.estimatedCost = Int(latestFinishedSession.estimatedCost)
    }
    
    // ResultViewに表示する時間を経過時間に応じて整形
    func timeString(from seconds: Int?) -> String {
        guard let seconds = seconds else { return "N/A" }
        
        if seconds < 60 {
            return "\(seconds) 秒"
        }
        
        let minutes = seconds / 60
        
        if minutes < 60 {
            return "\(minutes) 分"
        }
        
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        
        return "\(hours) 時間 \(remainingMinutes) 分"
    }
}
