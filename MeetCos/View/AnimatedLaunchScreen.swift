//
//  AnimatedLaunchScreen.swift
//  MeetCos
//
//  Created by apple on 2023/05/14.
//

import Lottie
import SwiftUI

struct AnimatedLaunchScreen: View {
    @Binding var animationFinished: Bool
    @State var title: String = ""

    var body: some View {
        VStack {
            LottieView(name: "insights", loopMode: .playOnce)
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.75)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2.5)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation(.easeOut(duration: 1.1)) {
                            animationFinished = true
                        }
                    }
                }
            Text(title).animation(.easeInOut(duration: 0.2))
                .font(.title)
                .font(.system(size: 24, weight: .bold, design: .default))
                .foregroundColor(Color("Color-2"))
                .padding(75)
            Spacer()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                title = ""
                "MeetCos".enumerated().forEach { index, character in
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.2) {
                        title += String(character)
                    }
                }
            }
        }
    }
}

struct LottieView: UIViewRepresentable {
    var name: String
    var loopMode: LottieLoopMode

    func makeUIView(context _: UIViewRepresentableContext<LottieView>) -> UIView {
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

    func updateUIView(_: UIView, context _: UIViewRepresentableContext<LottieView>) {}
}

struct AnimatedLaunchScreen_Previews: PreviewProvider {
    @State static var animationFinished: Bool = false

    static var previews: some View {
        AnimatedLaunchScreen(animationFinished: $animationFinished)
    }
}
