//
//  ContentView.swift
//  MeetCos
//
//  Created by apple on 2022/12/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State var selectddate = Date()
    @State var interval = "0:00"
    @State var totalCost = 0

    var body: some View {
        VStack {
            HStack {
                Text("終了予定時刻")
                    .padding()
                DatePicker("", selection: $selectddate, displayedComponents:
                        .hourAndMinute)
                .onChange(of: selectddate, perform: { value in
                    interval = viewModel.calcRemainingTime(value)
                   })
                .environment(\.locale, Locale(identifier: "en_DK"))
                .datePickerStyle(CompactDatePickerStyle())
                .padding()
                
            }
            ZStack (alignment: .center){
                Circle()
                    .stroke(Color.green, style: StrokeStyle(lineWidth:10))
                    .padding(50)
                Circle()
                    .trim(from: 0.0, to: 0.5)
                    .stroke(Color.yellow, style: StrokeStyle(lineWidth:10, lineCap: .round))
                    .scaledToFit()
                    .padding(50)
                    .rotationEffect(.degrees(-90))
                Text("残り時間   \(interval)")
                    .onAppear {
                        viewModel.start()
                    }
                
            }
            HStack {
//                Text("\(viewModel.count)")
//                Text("\(viewModel.remainingTime)")
                Button("Start") {
                    viewModel.start()
                }
                Button("Done") {
                    viewModel.stop()
                }
            }
            Spacer()
            Text("\(totalCost)円")
            Spacer()
            Button ("Edit") {
                
            }
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
