//
//  ContentView.swift
//  MeetCos
//
//  Created by apple on 2022/12/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State var selectdDate = Date()
    @State var displayTime = "0:00:00"
    @State var totalCost = 0
    @State var showingSheet = false

    var body: some View {
        VStack {
            HStack {
                Text("終了予定時刻")
                    .padding()
                DatePicker("", selection: $selectdDate, displayedComponents:
                        .hourAndMinute)
                .onChange(of: selectdDate, perform: { value in
                    viewModel.selectedDate = value
                    displayTime = viewModel.calcDisplayTime()
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
                    .trim(from: 0.0, to: viewModel.duration)
                    .stroke(Color.yellow, style: StrokeStyle(lineWidth:10, lineCap: .round))
                    .scaledToFit()
                    .padding(50)
                    .rotationEffect(.degrees(-90))
                Text("残り時間   \(viewModel.displayTime)")
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
            Button (action:{
                showingSheet = true
            }) {
                Text("Edit")
            }
            .sheet(isPresented: $showingSheet) {
                SheetView(container:  PersistenceController.shared.container)
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
