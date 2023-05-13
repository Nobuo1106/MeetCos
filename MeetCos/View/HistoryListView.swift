//
//  HistoryView.swift
//  MeetCos
//
//  Created by apple on 2023/05/06.
//

import SwiftUI

struct HistoryListView: View {
    @StateObject private var viewModel = HistoryListViewModel()
    @State private var showDetail = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.sessions) { session in
                    NavigationLink(destination: HistoryView(session: session)) {
                        HStack {
                            if let startedAt = session.startedAt {
                                Text("日時: \(startedAt, formatter: DateFormatter.shortDateAndTime)")
                            }
                            Spacer()
                            Text("コスト: ¥\(session.totalCost)")
                        }
                    }
                }
            }
            .navigationTitle("会議履歴")
            .onAppear {
                viewModel.fetchCompletedSessions()
            }
        }
    }
}

extension DateFormatter {
    static var shortDateAndTime: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
}

struct HistoryListView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryListView()
    }
}
