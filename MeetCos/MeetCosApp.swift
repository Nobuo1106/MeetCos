//
//  MeetCosApp.swift
//  MeetCos
//
//  Created by apple on 2022/12/24.
//

import SwiftUI

@main
struct MeetCosApp: App {
    @StateObject var timerViewModel: CountdownTimerViewModel
    @StateObject var homeViewModel: HomeViewModel
    @Environment(\.scenePhase) private var scenePhase
    @State var animationFinished = false
    
    init() {
        let timePickerViewModel = TimePickerViewModel()
        let timerViewModel = CountdownTimerViewModel(initialDuration: 0, groups: [])
        let homeViewModel = HomeViewModel(timePickerViewModel: timePickerViewModel, countdownTimerViewModel: timerViewModel)
        
        _timerViewModel = StateObject(wrappedValue: timerViewModel)
        _homeViewModel = StateObject(wrappedValue: homeViewModel)
    }
    
    var body: some Scene {
        WindowGroup {
            if shouldShowLaunchScreen() && !animationFinished {
                AnimatedLaunchScreen(animationFinished: $animationFinished)
            } else {
                TabBar()
                    .environmentObject(homeViewModel)
                    .environmentObject(timerViewModel)
                    .onChange(of: scenePhase) { newScenePhase in
                        switch newScenePhase {
                        case .background:
                            homeViewModel.appStateChanged(.background)
                        case .active:
                            homeViewModel.appStateChanged(.active)
                        case .inactive:
                            homeViewModel.appStateChanged(.inactive)
                        @unknown default:
                            homeViewModel.appStateChanged(.inactive)
                        }
                    }
            }
        }
    }
    
    func shouldShowLaunchScreen() -> Bool {
        let lastLaunchDate = UserDefaults.standard.object(forKey: "LastLaunchDate") as? Date
        let isMeetingOngoing = UserDefaults.standard.bool(forKey: "IsMeetingOngoing")
        
        guard let lastLaunch = lastLaunchDate, !isMeetingOngoing else {
            return true
        }
        
        let calendar = Calendar.current
        if let date = calendar.date(byAdding: .day, value: 3, to: lastLaunch), date > Date() {
            return false
        }
        
        return true
    }
}
