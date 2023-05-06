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
    @State private var showingResult = false
    
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
                        homeViewModel.updateSessionDuration()
                    }
                    .onChange(of: timePickerViewModel.minSelection) { _ in
                        homeViewModel.updateSessionDuration()
                    }
                    .disabled(homeViewModel.isRunning || $showingResult.wrappedValue)
            }
            .opacity(showingResult ? 0.3 : 1)

            ZStack(alignment: .center) {
                if showingResult {
                    ResultView(showingResult: $showingResult)
                } else {
                    Circle()
                        .stroke(Color.green, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .padding(50)
                    CountDownTimerView(viewModel: homeViewModel.countdownTimerViewModel)
                        .transition(.scale)
                }
            }
            .frame(height: 400)
            
            HStack {
                Button("Start") {
                    homeViewModel.start()
                }
                .disabled(homeViewModel.isRunning || $showingResult.wrappedValue)
                Button("Done") {
                    homeViewModel.stop()
                    homeViewModel.finishSession {
                        withAnimation {
                            showingResult = true
                        }
                    }
                    homeViewModel.countdownTimerViewModel.reset()
                }
                .disabled(!homeViewModel.isRunning || $showingResult.wrappedValue)
            }
            .opacity(showingResult ? 0.3 : 1)
            Spacer()
            Text("\(homeViewModel.totalCost)円")
                .opacity(showingResult ? 0 : 1)
            Spacer()
            Button (action:{
                showingSheet.toggle()
            }) {
                Text("Edit")
            }
            .opacity(showingResult ? 0.3 : 1)
            .disabled(homeViewModel.isRunning || $showingResult.wrappedValue)
            .sheet(isPresented: $showingSheet, onDismiss: {
                homeViewModel.getLatestSession { session in
                    SessionModel.shared.latestSession = session
                    homeViewModel.updateDisplayTime()
                }
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
