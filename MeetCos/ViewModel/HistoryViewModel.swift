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

    init(session: SessionProtocol) {
        self.session = session
        self.formattedStartedAt = Utility.formatDate(date: session.startedAt)
        self.formattedFinishedAt = Utility.formatDate(date: session.finishedAt)
    }
}
