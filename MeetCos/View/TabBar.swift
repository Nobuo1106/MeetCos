//
//  TabView.swift
//  MeetCos
//
//  Created by apple on 2023/05/06.
//

import SwiftUI


struct TabBar: View {
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    VStack {
                        Image(systemName: "house")
                        Text("ホーム")
                    }
                }
            HistoryListView()
                .tabItem {
                    VStack {
                        Image(systemName: "clock.arrow.2.circlepath")
                        Text("履歴")
                    }
                }
        }.accentColor(.green)
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        let mockTimePickerViewModel = TimePickerViewModel()
        let mockInitialDuration: Double = 0.0
        let mockGroups: [Group] = []
        
        let mockCountdownTimerViewModel = CountdownTimerViewModel(initialDuration: mockInitialDuration, groups: mockGroups)

        return TabBar()
            .environmentObject(HomeViewModel(timePickerViewModel: mockTimePickerViewModel, countdownTimerViewModel: mockCountdownTimerViewModel))
    }
}
