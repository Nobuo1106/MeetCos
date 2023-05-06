//
//  ResultView.swift
//  MeetCos
//
//  Created by apple on 2023/05/01.
//

import SwiftUI

struct ResultView: View {
    @Binding var showingResult: Bool
    @StateObject private var viewModel = ResultViewModel()
    
    var body: some View {
        VStack(spacing: 10) {
            Text("MTG結果")
            Spacer()
            Text("時間：\(viewModel.timeString(from: viewModel.totalSeconds ?? 0))")
            Text("予定時間：\(viewModel.timeString(from: viewModel.estimatedSeconds ?? 0))")
            Text("経費 ¥： \(viewModel.totalCost ?? 0)")
            Text("予定経費 ¥：\(viewModel.estimatedCost ?? 0)")
            Spacer()

            Button(action: {
                withAnimation {
                    showingResult = false
                }
            }) {
                Text("再度MTGを開始する")
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        Color("Color-1")
                    )
                    .foregroundColor(Color("Color-2"))
                    .cornerRadius(12.0)
                    .padding()
            }
        }
        .padding()
        .frame(maxWidth: 300, maxHeight: 350)
        .background(Color("backGroundColor"))
        .cornerRadius(CGFloat(21.0))
        .shadow(radius: 10, x: 5, y: 5)
        .transition(.scale)
    }
}

struct ResultView_Previews: PreviewProvider {
    static private var showingResult = Binding.constant(false)
    static var previews: some View {
        ResultView(showingResult: showingResult)
    }
}
