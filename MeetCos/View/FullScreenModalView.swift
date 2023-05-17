//
//  FullScreenModalView.swift
//  MeetCos
//
//  Created by apple on 2023/05/18.
//

import SwiftUI

struct FullScreenModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var model = WebViewModel()
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            LoadingView(isLoading: self.$model.isLoading) {
                       UrlWebView(viewModel: self.model, isLoading: self.$model.isLoading)
            }
        }
    }
}

struct FullScreenModalView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenModalView()
    }
}
