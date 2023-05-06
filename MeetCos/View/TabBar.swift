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
            HistoryView()
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
        TabBar()
    }
}
