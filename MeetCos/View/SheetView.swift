//
//  SheetView.swift
//  MeetCos
//
//  Created by apple on 2023/01/13.
//

import SwiftUI

struct SheetView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
      NavigationView {
          VStack {
            FormView()
          }
        .navigationBarItems(leading: Button("キャンセル") {
            self.presentationMode.wrappedValue.dismiss()
        })
        .navigationBarItems(trailing: Button("完了") {
            self.presentationMode.wrappedValue.dismiss()
        })
      }
    }
}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView()
    }
}
