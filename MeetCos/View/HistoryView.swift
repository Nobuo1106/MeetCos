//
//  HistoryDetailView.swift
//  MeetCos
//
//  Created by apple on 2023/05/07.
//

import SwiftUI

struct HistoryView: View {
    let session: SessionProtocol
    @ObservedObject private var viewModel: HistoryViewModel
    
    init(session: SessionProtocol) {
        self.session = session
        self.viewModel = HistoryViewModel(session: session)
    }
    
    var body: some View {
        VStack {
            Text("会議詳細")
                .padding()
                .foregroundColor(.green)
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("開始時刻:")
                        .font(.headline)
                    if (session.startedAt) != nil {
                        Text(viewModel.formattedStartedAt)
                    }
                }
                
                HStack {
                    Text("終了時刻:")
                        .font(.headline)
                    if (session.startedAt) != nil {
                        Text(viewModel.formattedFinishedAt)
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
                    Text(Utility.timeString(from: Int(session.duration)))
                }
                
                HStack {
                    Text("コスト差:")
                        .font(.headline)
                    Text("¥\(session.totalCost - session.estimatedCost)")
                }
            }
            .padding()
            .frame(maxWidth: 300, maxHeight: 350)
            .background(Color("Color-3"))
            .cornerRadius(CGFloat(21.0))
            .shadow(radius: 10, x: 5, y: 5)
        .transition(.scale)
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
    var groups: Set<Group> = [] 
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

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        let mockSession = MockSession.sampleSession
        
        return NavigationView {
            HistoryView(session: mockSession)
        }
    }
}
