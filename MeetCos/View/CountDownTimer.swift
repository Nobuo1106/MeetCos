//
//  CountDownTimer.swift
//  MeetCos
//
//  Created by apple on 2023/04/09.
//

import Foundation
import SwiftUI

struct CountDownTimerView: Shape {
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
