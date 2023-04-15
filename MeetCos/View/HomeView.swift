//
//  ContentView.swift
//  MeetCos
//
//  Created by apple on 2022/12/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var timePickerViewModel = TimePickerViewModel()
    @StateObject private var homeViewModel: HomeViewModel
    @State private var showingSheet = false
    
    init() {
        let timePickerVM = TimePickerViewModel()
        _timePickerViewModel = StateObject(wrappedValue: timePickerVM)
        _homeViewModel = StateObject(wrappedValue: HomeViewModel(timePickerViewModel: timePickerVM))
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("会議時間")
                    .padding()
                TimePickerView(viewModel: timePickerViewModel)
                    .onChange(of: timePickerViewModel.hourSelection) { _ in
                        homeViewModel.saveSession()
                    }
                    .onChange(of: timePickerViewModel.minSelection) { _ in
                        homeViewModel.saveSession()
                    }
            }
            ZStack(alignment: .center) {
                Circle()
                    .stroke(Color.green, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .padding(50)
                CountDownTimerView(viewModel: homeViewModel.countdownTimerViewModel)
            }
            HStack {
                //                Text("\(homeViewModel.count)")
                //                Text("\(homeViewModel.remainingTime)")
                Button("Start") {
                    homeViewModel.start()
                }
                Button("Done") {
                    homeViewModel.stop()
                }
            }
            Spacer()
            Text("\(homeViewModel.totalCost)円")
            Spacer()
            Button (action:{
                showingSheet.toggle()
            }) {
                Text("Edit")
            }
            .sheet(isPresented: $showingSheet, onDismiss: {
                homeViewModel.getLatestSession(completion: {
                    homeViewModel.updateDisplayTime()
                })
            }) {
                SheetView()
            }
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var timePickerViewModel = TimePickerViewModel()
    
    static var previews: some View {
        HomeView()
            .environmentObject(timePickerViewModel)
    }
}
