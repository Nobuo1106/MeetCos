//
//  ContentView.swift
//  MeetCos
//
//  Created by apple on 2022/12/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var timerViewModel: CountdownTimerViewModel
    @State private var showingSheet = false
    @State private var showingResult = false
    
    var body: some View {
        VStack {
            HStack {
                Text("会議時間")
                    .padding()
                TimePickerView()
                    .environmentObject(homeViewModel.timePickerViewModel)
                    .onChange(of: homeViewModel.timePickerViewModel.hourSelection) { _ in
                        homeViewModel.updateSessionDuration()
                    }
                    .onChange(of: homeViewModel.timePickerViewModel.minSelection) { _ in
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
                Button("スタート") {
                    homeViewModel.start()
                }
                .bold()
                .padding()
                .frame(maxWidth: 175)
                .background(!homeViewModel.isRunning ? AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [Color("Color-1"), Color("Color-2")]), startPoint: .leading, endPoint: .trailing)): AnyShapeStyle(Color(.gray)))
            
                .foregroundColor(.white)
                .cornerRadius(12.0)
                .padding()
                .disabled(homeViewModel.isRunning || $showingResult.wrappedValue || homeViewModel.estimatedTotalCost == 0)
                Button("ストップ") {
                    homeViewModel.stop()
                    homeViewModel.finishSession {
                        withAnimation {
                            showingResult = true
                        }
                    }
                    homeViewModel.countdownTimerViewModel.reset()
                }
                .bold()
                .padding()
                .frame(maxWidth: 175)
                .background(homeViewModel.isRunning ? AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [Color(.yellow), Color(.red)]), startPoint: .leading, endPoint: .trailing)) : AnyShapeStyle(Color(.gray)))
            
                .foregroundColor(.white)
                .cornerRadius(12.0)
                .padding()
                .disabled(!homeViewModel.isRunning || $showingResult.wrappedValue)
            }
            .opacity(showingResult ? 0.3 : 1)
            Spacer()
            Text("想定コスト ¥\(homeViewModel.estimatedTotalCost)")
                .kerning(2.0)
                .font(.footnote)
                .opacity(showingResult ? 0 : 1)
            Spacer()
            Button (action:{
                showingSheet.toggle()
            }) {
                Text("編集")
            }
            .bold()
            .padding()
            .frame(maxWidth: 175)
            .background(!homeViewModel.isRunning ? AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [Color(.yellow), Color(.red)]), startPoint: .leading, endPoint: .trailing)) : AnyShapeStyle(Color(.gray)))
        
            .foregroundColor(.white)
            .cornerRadius(12.0)
            .padding()
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
    static var countdownTimerViewModel = CountdownTimerViewModel(initialDuration: 0, groups: [])
    static var homeViewModel = HomeViewModel(timePickerViewModel: timePickerViewModel, countdownTimerViewModel: countdownTimerViewModel)
    
    static var previews: some View {
        HomeView()
            .environmentObject(homeViewModel)
            .environmentObject(countdownTimerViewModel)
    }
}
