//
//  HistoryListView.swift
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
            VStack {
                Text("会議一覧")
                    .padding()
                    .foregroundColor(.green)
                if viewModel.sessions.isEmpty {
                    List {
                        Text("まだ会議の履歴はありません")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    }
                } else {
                    List {
                        ForEach(viewModel.sessions) { session in
                            NavigationLink(destination: HistoryView(session: session)) {
                                HStack {
                                    if let startedAt = session.startedAt {
                                        Text(" \(startedAt, formatter: DateFormatter.shortDateAndTime)")
                                    }
                                    Spacer()
                                    Text(" ¥\(session.totalCost)")
                                }
                            }
                        }
                    }
                }
            }.onAppear {
                viewModel.fetchCompletedSessions()
            }
        }
    }
}

extension DateFormatter {
    static var shortDateAndTime: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.M.dd H:mm"
        return formatter
    }
}

struct HistoryListView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryListView()
    }
}
