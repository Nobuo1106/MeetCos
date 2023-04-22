//
//  CountDownTimerViewModel.swift
//  MeetCos
//
//  Created by apple on 2023/04/09.
//

import Foundation
import Combine

class CountdownTimerViewModel: ObservableObject {
    @Published var initialDuration: Double
    @Published var remainingTime: Double
    @Published var displayTime: String = "0:00:00"
    @Published var totalCost: Double = 0.0
    @Published var progress: Double = 0
    private var costPerSecond: Double = 0.0
    private var timer: Timer?
    
    init(initialDuration: Double, groups: [Group]) {
        self.remainingTime = initialDuration
        self.initialDuration = initialDuration
        updateCostPerSecond(groups: groups)
    }
    
    func start() {
        stop() // Ensure any existing timer is stopped before starting a new one

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            if self.remainingTime > 0 {
                self.remainingTime -= 1
                self.totalCost += self.costPerSecond
                self.updateProgress()
            } else {
                self.stop()
            }
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateDuration(newDuration: Double) {
        self.initialDuration = newDuration * 60
        self.remainingTime = newDuration * 60
    }
    
    var formattedRemainingTime: String {
        let hours = Int(remainingTime) / 3600
        let minutes = (Int(remainingTime) % 3600) / 60
        let seconds = Int(remainingTime) % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
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
    
    var formattedTotalCost: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "¥"
        formatter.maximumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: totalCost)) ?? ""
    }
    
    func updateProgress() {
        progress = 1 - (remainingTime / initialDuration)
    }
}
