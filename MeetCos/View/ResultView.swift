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
        VStack {
            Text("MTG結果")
            Spacer()
            HStack {
                VStack (alignment: .trailing) {
                    Text("想定時間 :")
                        .padding(.bottom, 3)
                    Text("会議時間 :")
                        .padding(.bottom, 3)
                    Text("想定コスト:")
                        .padding(.bottom, 3)
                    Text("合計コスト:")
                        .padding(.bottom, 3)
                }
                
                VStack (alignment: .leading) {
                    Text("\(Utility.timeString(from: viewModel.estimatedSeconds ?? 0))")
                        .padding(.bottom, 3)
                    Text("\(Utility.timeString(from: viewModel.totalSeconds ?? 0))")
                        .padding(.bottom, 3)
                    Text("¥ \(viewModel.estimatedCost ?? 0)")
                        .padding(.bottom, 3)
                    Text("¥ \(viewModel.totalCost ?? 0)")
                        .padding(.bottom, 3)
                }
            }
            .foregroundColor(.black)
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
                    .background(LinearGradient(gradient: Gradient(colors: [Color("Color-1"), Color("Color-2")]), startPoint: .leading, endPoint: .trailing))
                
                    .foregroundColor(.white)
                    .cornerRadius(12.0)
                    .padding()
            }
        }
        .padding()
        .frame(maxWidth: 300, maxHeight: 350)
        .background(Color("Color-3"))
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
