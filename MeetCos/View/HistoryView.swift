//
//  HistoryDetailView.swift
//  MeetCos
//
//  Created by apple on 2023/05/07.
//

import SwiftUI

struct HistoryView: View {
    let session: SessionProtocol
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("開始時刻:")
                    .font(.headline)
                if let startedAt = session.startedAt {
                    Text("\(startedAt, formatter: DateFormatter.shortDateAndTime)")
                }
            }
            
            HStack {
                Text("終了時刻:")
                    .font(.headline)
                if let finishedAt = session.finishedAt {
                    Text("\(finishedAt, formatter: DateFormatter.shortDateAndTime)")
                }
            }
            
            HStack {
                Text("予想コスト:")
                    .font(.headline)
                Text("¥\(session.estimatedCost)")
            }
            
            HStack {
                Text("合計コスト:")
                    .font(.headline)
                Text("¥\(session.totalCost)")
            }
            
            HStack {
                Text("合計時間:")
                    .font(.headline)
                Text("\(Int(session.duration)) 分")
            }
            
            HStack {
                Text("コスト差:")
                    .font(.headline)
                Text("¥\(session.totalCost - session.estimatedCost)")
            }
        }
        .padding()
        .navigationTitle("会議詳細")
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HistoryView(session: MockSession.sampleSession)
        }
    }
}

struct MockSession: SessionProtocol {
    var sessionId: Int64 = 1
    var startedAt: Date? = Date().addingTimeInterval(-60 * 60)
    var finishedAt: Date? = Date()
    var willFinishAt: Date? = Date().addingTimeInterval(60 * 60)
    var createdAt: String = "2023-05-07"
    var updatedAt: String = "2023-05-07"
    var duration: Double = 3600
    var estimatedCost: Int64 = 1000
    var totalCost: Int64 = 1200
    var groups: Set<Group> = [] // You need to define some mock groups here if you need them
}


extension MockSession {
    static var sampleSession: MockSession {
        MockSession(sessionId: 1,
                    startedAt: Date().addingTimeInterval(-60 * 60),
                    finishedAt: Date(),
                    willFinishAt: Date().addingTimeInterval(60 * 60),
                    createdAt: "2023020294",
                    updatedAt: "2023023033",
                    duration: 3600,
                    estimatedCost: 1000,
                    totalCost: 1200)
    }
}
