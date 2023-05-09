//
//  HistoryViewModel.swift
//  MeetCos
//
//  Created by apple on 2023/05/07.
//

import Foundation

class HistoryViewModel: ObservableObject, HistoryViewModelProtocol {
    var session: Session

    init(session: Session) {
        self.session = session
    }
}
