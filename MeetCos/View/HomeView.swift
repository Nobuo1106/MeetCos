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
            ZStack(alignment: .center) {
                Circle()
                    .stroke(Color.green, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .padding(50)
                ClockwiseProgress(progress: viewModel.duration)
                    .stroke(Color.yellow, style: StrokeStyle(lineWidth: 10))
                    .scaledToFit()
                    .padding(50)
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
                SheetView()
            }
            Spacer()
        }
        .padding()
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
    static var previews: some View {
        HomeView()
    }
}
