//
//  HistoryListViewModel.swift
//  MeetCos
//
//  Created by apple on 2023/05/07.
//

import SwiftUI

class HistoryListViewModel: ObservableObject, HistoryListViewModelProtocol {
    @Published var sessions: [Session] = []

    func fetchCompletedSessions() {
        SessionModel.shared.fetchCompletedSessions { [weak self] completedSessions in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.sessions = completedSessions
            }
        }
    }
}
