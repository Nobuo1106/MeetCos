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
        let homeVM = HomeViewModel(timePickerViewModel: timePickerVM)
        
        _timePickerViewModel = StateObject(wrappedValue: timePickerVM)
        _homeViewModel = StateObject(wrappedValue: homeVM)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("会議時間")
                    .padding()
                TimePickerView(viewModel: timePickerViewModel, isRunning: $homeViewModel.isRunning)
                    .onChange(of: timePickerViewModel.hourSelection) { _ in
                        homeViewModel.saveSession()
                    }
                    .onChange(of: timePickerViewModel.minSelection) { _ in
                        homeViewModel.saveSession()
                    }
                    .disabled(homeViewModel.isRunning)
            }
            ZStack(alignment: .center) {
                Circle()
                    .stroke(Color.green, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .padding(50)
                CountDownTimerView(viewModel: homeViewModel.countdownTimerViewModel)
            }
            HStack {
                Button("Start") {
                    homeViewModel.start()
                }
                .disabled(homeViewModel.isRunning)
                Button("Done") {
                    homeViewModel.stop()
                    homeViewModel.finishSession()
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
            .disabled(homeViewModel.isRunning)
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
