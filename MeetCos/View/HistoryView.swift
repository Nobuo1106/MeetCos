//
//  HistoryDetailView.swift
//  MeetCos
//
//  Created by apple on 2023/05/07.
//

import SwiftUI

import SwiftUI

struct HistoryView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Started At: 9:00 AM")
            Text("Finished At: 12:00 PM")
            Text("Estimated Cost: ¥1000")
            Text("Total Cost: ¥1200")
            Text("Total Time: 3 hours")
            Text("Gap Cost: ¥200")
        }
        .padding()
        .navigationTitle("History Detail")
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
