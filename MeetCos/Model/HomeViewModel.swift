//
//  File.swift
//  MeetCos
//
//  Created by apple on 2023/01/08.
//

import Foundation
import Combine

extension HomeView {
    class HomeViewModel: ObservableObject {
        @Published var interval: String = "0:00"
        @Published var remainingTime: Double = 0.0
        @Published var stateDate = Date()
        @Published var timer: AnyCancellable!
        @Published var count: Int = 0
        @Published var isTimer = true
        
        func calcRemainingTime (_ selected: Date)-> String{
            let interval = selected.timeIntervalSinceNow
            self.remainingTime = interval
            if self.remainingTime < 0 {
                self.isTimer = false
            }
            print(self.remainingTime)
            let dateFormatter = DateComponentsFormatter()
            dateFormatter.unitsStyle = .positional
            dateFormatter.allowedUnits = [.hour, .minute]
            dateFormatter.zeroFormattingBehavior = .pad
            print(dateFormatter.string(from: interval)!)
            return dateFormatter.string(from: interval)!
        }
        
        func start() {
            self.count()
        }
        
        func count(_ interval: Double = 0.1){
            print("start Timer")
            // TimerPublisherが存在しているときは念の為処理をキャンセル
            if let _timer = timer{
                _timer.cancel()
            }

            timer = Timer.publish(every: interval, on: .main, in: .common)
                .autoconnect()
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: ({_ in
//                    self.count += 1
                    self.remainingTime -= 0.1
                    if self.remainingTime < 0 {
                        self.stop()
                    }
            }))

        }
        
        // タイマーの停止
        func stop(){
            print("stop Timer")
            timer?.cancel()
            timer = nil
        }
    }
}
