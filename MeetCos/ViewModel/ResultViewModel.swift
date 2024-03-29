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
           let finishedAt = latestFinishedSession.finishedAt
        {
            let interval = finishedAt.timeIntervalSince(startedAt)
            print(interval)
            totalSeconds = Int(interval)
        } else {
            totalSeconds = 0
        }
        totalCost = Int(latestFinishedSession.totalCost)
        estimatedSeconds = Int(latestFinishedSession.duration) * 60
        estimatedCost = Int(latestFinishedSession.estimatedCost)
    }
}
