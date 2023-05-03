//
//  ResultView.swift
//  MeetCos
//
//  Created by apple on 2023/05/01.
//

import SwiftUI

struct ResultView: View {
    @Binding var showingResult: Bool
    
    var body: some View {
        VStack(spacing: 10) {

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
            }
        }
        .padding()
        .frame(maxWidth: 300, minHeight: 400)
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
