//
//  File.swift
//  MeetCos
//
//  Created by apple on 2023/01/08.
//

import Foundation
extension HomeView {
    @MainActor class HomeViewModel: ObservableObject {
        @Published var remainingTime: String = "0:00"
        @Published var stateDate = Date()
        
        func calcRemainingTime (_ selected: Date)-> String{
            let interval = selected.timeIntervalSinceNow
            let dateFormatter = DateComponentsFormatter()
            dateFormatter.unitsStyle = .positional
            dateFormatter.allowedUnits = [.hour, .minute]
            dateFormatter.zeroFormattingBehavior = .pad
            print(dateFormatter.string(from: interval)!)
            return dateFormatter.string(from: interval)!
        }
    }
}
