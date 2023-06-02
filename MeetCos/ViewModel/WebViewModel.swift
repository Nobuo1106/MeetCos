//
//  WebViewModel.swift
//  MeetCos
//
//  Created by apple on 2023/05/18.
//

import Foundation

class WebViewModel: ObservableObject {
    @Published var url: String = "https://meet-cos-privacy-policy.vercel.app/privacy.html"
    @Published var isLoading: Bool = true
}
