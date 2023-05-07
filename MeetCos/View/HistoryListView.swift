//
//  HistoryView.swift
//  MeetCos
//
//  Created by apple on 2023/05/06.
//

import SwiftUI

import SwiftUI

struct HistoryListView: View {
    @State private var showDetail = false
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<5) { index in
                    NavigationLink(destination: HistoryView()) {
                        HStack {
                            Text(" \(index + 1)")
                            Spacer()
                            Text("日時: 203/4/4 4:56")
                            Spacer()
                            Text("コスト: ¥1200")
                        }
                    }
                }
            }
            .navigationTitle("会議履歴")
        }
    }
}

struct HistoryListView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryListView()
    }
}
