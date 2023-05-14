//
//  AnimatedLaunchScreen.swift
//  MeetCos
//
//  Created by apple on 2023/05/14.
//

import SwiftUI
import Lottie

struct AnimatedLaunchScreen: View {
    @Binding var animationFinished: Bool
    var body: some View {
        LottieView(name: "insights", loopMode: .playOnce)
            .aspectRatio(contentMode: .fit)
            .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.75)
            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeOut(duration: 1.1)) {
                        animationFinished = true
                    }
                }
            }
    }
}

struct LottieView: UIViewRepresentable {
    var name: String
    var loopMode: LottieLoopMode
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView()
        let animatiion = LottieAnimation.named("insights")
        animationView.animation = animatiion
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {}
}
