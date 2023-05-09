//
//  HistoryDetailView.swift
//  MeetCos
//
//  Created by apple on 2023/05/07.
//

import SwiftUI

struct HistoryView: View {
    let session: Session
    
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
            HistoryView(session: Session.sampleSession)
        }
    }
}
