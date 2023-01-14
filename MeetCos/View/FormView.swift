//
//  FormView.swift
//  MeetCos
//
//  Created by apple on 2023/01/13.
//

import SwiftUI

struct FormView: View {
    var body: some View {
        Form {
            Section {
                Text("部品１")
                Text("部品２")
            }
            
            Section {
                Text("部品３")
                Text("部品４")
            } header: {
                Text("ヘッダーテキスト")
            } footer: {
                Text("フッターテキスト")
            }
        }
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView()
    }
}
