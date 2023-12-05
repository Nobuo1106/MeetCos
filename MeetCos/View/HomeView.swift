//
//  HomeView.swift
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
        GeometryReader { geometry in
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
                .frame(height: geometry.size.height / 2.50)

                HStack {
                    Button(action: {
                        homeViewModel.start()
                    }) {
                        Text("スタート")
                            .bold()
                            .font(.callout)
                            .padding()
                            .frame(maxWidth: 175)
                            .background(
                                !homeViewModel.isRunning && homeViewModel.estimatedTotalCost != 0 ?
                                    RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white, lineWidth: 5)
                                    .background(Color("Color-1"))
                                    : RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white, lineWidth: 5)
                                    .background(Color("Color-6")
                                    )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .padding()
                    }
                    .disabled(homeViewModel.isRunning || $showingResult.wrappedValue || homeViewModel.estimatedTotalCost == 0)
                    Button(action: {
                        homeViewModel.stop()
                        homeViewModel.finishSession {
                            withAnimation {
                                showingResult = true
                            }
                        }
                        homeViewModel.countdownTimerViewModel.reset()
                    }) {
                        Text("ストップ")
                            .bold()
                            .font(.callout)
                            .padding()
                            .frame(maxWidth: 175)
                            .background(
                                !homeViewModel.isRunning ?
                                    RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white, lineWidth: 5)
                                    .background(Color("Color-6"))
                                    : RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white, lineWidth: 5)
                                    .background(Color("Color-1"))
                            )
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .padding()
                    }
                    .disabled(!homeViewModel.isRunning || $showingResult.wrappedValue)
                }
                .opacity(showingResult ? 0.3 : 1)
                Spacer()
                Text("想定コスト ¥\(homeViewModel.estimatedTotalCost)")
                    .kerning(2.0)
                    .font(.footnote)
                    .opacity(showingResult ? 0 : 1)
                Spacer()

                Button(action: {
                    showingSheet.toggle()
                }) {
                    Text("編集")
                        .bold()
                        .foregroundColor(.green)
                        .padding()
                        .frame(maxWidth: 175)
                }
                .background(
                    !homeViewModel.isRunning ?
                        RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.green, lineWidth: 5)
                        .background(Color.white)
                        : RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray, lineWidth: 3)
                        .background(Color("Color-5"))
                )
                .cornerRadius(20)
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
