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

    var body: some View {
        VStack {
            HStack {
                Text("終了日時")
                    .padding()
                DatePicker("", selection: $selectddate, displayedComponents:
                        .hourAndMinute)
                .onChange(of: selectddate, perform: { value in
                    interval = viewModel.calcRemainingTime(value)
//                    print(type(of: value))
                   })
                .environment(\.locale, Locale(identifier: "en_DK"))
                .datePickerStyle(CompactDatePickerStyle())
                .padding()
                
            }
            Text("残り時間   \(interval)")
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
            }
            
            Spacer()
//            Text("Your current date is \(viewModel.stateDate)")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
