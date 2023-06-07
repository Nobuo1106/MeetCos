//
//  CountDownTimerViewModel.swift
//  MeetCos
//
//  Created by apple on 2023/04/09.
//

import Combine
import Foundation

class CountdownTimerViewModel: ObservableObject {
    @Published var initialDuration: Double
    @Published var remainingTime: Double {
        didSet {
            if remainingTime < 0 && initialDuration > 0 {
                // 予定時刻をオーバーした場合
                isOvertime = true
            }
        }
    }

    @Published var displayTime: String = "0:00:00"
    @Published var totalCost: Double = 0.0
    @Published var progress: Double = 0
    @Published var isOvertime: Bool = false
    private var costPerSecond: Double = 0.0
    private var timer: Timer?
    private var totalDuration: Double = 0.0
    var backgroundTime: Date?

    init(initialDuration: Double, groups: [Group]) {
        remainingTime = initialDuration
        self.initialDuration = initialDuration
        updateCostPerSecond(groups: groups)
    }

    func start() {
        stop()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
            }

            self.remainingTime -= 1
            self.totalCost += self.costPerSecond
            self.updateProgress()
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    func reset() {
        remainingTime = 0
        totalCost = 0
        progress = 0
        isOvertime = false
    }

    func updateDuration(newDuration: Double) {
        initialDuration = newDuration * 60
        remainingTime = newDuration * 60
    }

    func initializeTotalCost(groups: [Group]) {
        updateCostPerSecond(groups: groups)
        totalCost = 0.0
    }

    private func updateCostPerSecond(groups: [Group]) {
        costPerSecond = 0.0
        for group in groups {
            let totalHourlyCost = group.hourlyWage + group.hourlyProfit
            costPerSecond += (Double(totalHourlyCost) * Double(group.personCount)) / 3600.0
        }
    }

    func updateProgress() {
        if remainingTime < 0 {
            let tempRemainingTime = remainingTime * -1
            progress = tempRemainingTime / initialDuration
        } else {
            progress = 1 - (remainingTime / initialDuration)
        }
    }

    var formattedTotalCost: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "¥"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: totalCost)) ?? ""
    }

    var formattedRemainingTime: String {
        let hours = abs(Int(remainingTime)) / 3600
        let minutes = abs(Int(remainingTime) % 3600) / 60
        let seconds = abs(Int(remainingTime)) % 60

        if isOvertime {
            return "+ \(String(format: "%02d:%02d:%02d", hours, minutes, seconds))"
        } else {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }

    func appMovedToBackground() {
        backgroundTime = Date()
        print(backgroundTime!)
    }

    func appMovedToForeground() {
        if let backgroundTime = backgroundTime {
            let elapsedTime = Date().timeIntervalSince(backgroundTime)
            print(elapsedTime)
            print(remainingTime)
            remainingTime -= elapsedTime
            print(remainingTime)
            totalCost += costPerSecond * elapsedTime
            updateProgress()
            self.backgroundTime = nil
        }
    }
}
