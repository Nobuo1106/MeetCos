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
    
    init() {
        fetchLatestFinishedSession()
    }

    func fetchLatestFinishedSession() {
        SessionModel.shared.fetchLatestFinishedSession { session in
            self.latestFinishedSession = session
        }
    }
    
    static func dummyInstance() -> ResultViewModel {
        let viewModel = ResultViewModel()
        viewModel.latestFinishedSession = Session()
        return viewModel
    }
}
