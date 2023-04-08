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
                ClockwiseProgress(progress: homeViewModel.duration)
                    .stroke(Color.yellow, style: StrokeStyle(lineWidth: 10))
                    .scaledToFit()
                    .padding(50)
                Text("残り時間   \(homeViewModel.displayTime)")
                    .onAppear {
                        homeViewModel.start()
                    }
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
        .onAppear {
            homeViewModel.getLatestSession(completion: {
                homeViewModel.updateDisplayTime()
            })
        }
    }
}

struct ClockwiseProgress: Shape {
    var progress: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: rect.width / 2,
                    startAngle: Angle(degrees: -90),
                    endAngle: Angle(degrees: -90 + 360 * Double(progress)),
                    clockwise: true)
        return path
    }
}

struct CircleCap: View {
    var progress: CGFloat
    var lineWidth: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let radius = geometry.size.width / 2 - lineWidth / 2
            let capX = center.x + radius * cos(CGFloat(-90 + 360 * Double(progress)) * CGFloat.pi / 180)
            let capY = center.y + radius * sin(CGFloat(-90 + 360 * Double(progress)) * CGFloat.pi / 180)
            Circle()
                .frame(width: lineWidth, height: lineWidth)
                .position(x: capX, y: capY)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var timePickerViewModel = TimePickerViewModel()
    
    static var previews: some View {
        HomeView()
            .environmentObject(timePickerViewModel)
    }
}
