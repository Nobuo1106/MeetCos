//
//  WebViewModel.swift
//  MeetCos
//
//  Created by apple on 2023/05/18.
//

import Foundation

class WebViewModel: ObservableObject {
    @Published var url: String = "https://doc-hosting.flycricket.io/meetcos-privacy-policy/d7495ed9-7564-4d05-82ab-57c53234470b/privacy"
    @Published var isLoading: Bool = true
}
