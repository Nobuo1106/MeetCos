//
//  TabView.swift
//  MeetCos
//
//  Created by apple on 2023/05/06.
//

import SwiftUI

struct TabBar: View {
    init() {
        let color = Color("tabBarBackground")
        let uiColor = UIColor(color)
        UITabBar.appearance().backgroundColor = uiColor
    }

    var body: some View {
        VStack {
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
                FullScreenModalView()
                    .tabItem {
                        VStack {
                            Image(systemName: "link")
                            Text("プライバシーポリシー")
                        }
                    }
            }
            .frame(
                width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.height
            )
            .accentColor(.green)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                UserDefaults.standard.set(Date(), forKey: "LastLaunchDate")
            }
        }
        .edgesIgnoringSafeArea(.all)
        Spacer()
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
