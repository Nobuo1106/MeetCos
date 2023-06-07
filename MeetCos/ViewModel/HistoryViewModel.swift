//
//  HistoryViewModel.swift
//  MeetCos
//
//  Created by apple on 2023/05/07.
//

import Foundation

class HistoryViewModel: ObservableObject, HistoryViewModelProtocol {
    @Published var session: SessionProtocol
    @Published var formattedStartedAt: String
    @Published var formattedFinishedAt: String
    var totalSeconds: Int {
        guard let startedAt = session.startedAt,
              let finishedAt = session.finishedAt else { return 0 }

        let interval = finishedAt.timeIntervalSince(startedAt)
        return Int(interval)
    }

    init(session: SessionProtocol) {
        self.session = session
        formattedStartedAt = Utility.formatDate(date: session.startedAt)
        formattedFinishedAt = Utility.formatDate(date: session.finishedAt)
    }
}
