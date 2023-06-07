//
//  WebView.swift
//  MeetCos
//
//  Created by apple on 2023/05/18.
//

import SwiftUI
import WebKit

struct UrlWebView: UIViewRepresentable {
    @ObservedObject var viewModel: WebViewModel
    @Binding var isLoading: Bool
    let webView = WKWebView()

    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        private var viewModel: WebViewModel

        init(_ viewModel: WebViewModel) {
            self.viewModel = viewModel
        }

        func webView(_: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
            viewModel.isLoading = true
        }

        func webView(_: WKWebView, didFinish _: WKNavigation!) {
            viewModel.isLoading = false
        }

        func webView(_: WKWebView, didFail _: WKNavigation!, withError error: Error) {
            print(error)
        }
    }

    func updateUIView(_: UIView, context _: UIViewRepresentableContext<UrlWebView>) {}

    func makeUIView(context: Context) -> UIView {
        webView.navigationDelegate = context.coordinator
        webView.backgroundColor = .clear
        webView.isOpaque = false

        if let url = URL(string: viewModel.url) {
            webView.load(URLRequest(url: url))
        }

        return webView
    }
}

// ローディング中か判定して出すビューの切り替え
struct ActivityIndicatorView: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context _: UIViewRepresentableContext<ActivityIndicatorView>) -> UIActivityIndicatorView {
        UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context _: UIViewRepresentableContext<ActivityIndicatorView>) {
        if isAnimating {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}

// WebViewローディング用のカスタムインジケーター
struct LoadingView<Content>: View where Content: View {
    @State private var downloadAmount = 0.0
    @Binding var isLoading: Bool
    var content: () -> Content
    var body: some View {
        let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
        GeometryReader { geometry in
            ZStack {
                content()
                    .disabled(isLoading)
                ProgressView("", value: downloadAmount, total: 100)
                    .onReceive(timer) { _ in
                        if downloadAmount < 100 {
                            downloadAmount += 2
                        }
                    }
                    .scaleEffect(x: 1, y: 0.75, anchor: .center)
                    .accentColor(Color(red: 0.915, green: 0.447, blue: 0.445))
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.05)
                    .opacity(isLoading ? 1 : 0)

                VStack {
                    ActivityIndicatorView(isAnimating: .constant(true), style: .medium)
                        .foregroundColor(.pink)
                        .frame(alignment: .center)
                }
                .opacity(isLoading ? 1 : 0)
            }
        }
    }
}
