//
//  CountDownTimer.swift
//  MeetCos
//
//  Created by apple on 2023/04/09.
//

import Foundation
import SwiftUI

struct CountDownTimerView: View {
    @ObservedObject var viewModel: CountdownTimerViewModel
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.green, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .padding(50)
            ClockwiseProgress(progress: CGFloat(viewModel.progress))
                .stroke(Color.yellow, style: StrokeStyle(lineWidth: 10))
                .scaledToFit()
                .padding(50)
            VStack {
                Text("残り時間: \(viewModel.formattedRemainingTime)")
                Text("経費：\(viewModel.formattedTotalCost)")
            }
        }
    }
}

struct ClockwiseProgress: Shape {
    var progress: CGFloat = 0.0
    
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
