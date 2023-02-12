//
//  SheetView.swift
//  MeetCos
//
//  Created by apple on 2023/01/13.
//

import SwiftUI

struct SheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var viewModel = SheetViewModel()
    @FocusState private var focus: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                FormView()
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Button("閉じる") {
                            focus = false
                        }

                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .navigationBarItems(leading: Button("キャンセル") {
                self.presentationMode.wrappedValue.dismiss()
            })
            .navigationBarItems(trailing: Button("完了") {
                self.presentationMode.wrappedValue.dismiss()
                viewModel.save()
            })
        }
    }
}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView()
    }
}
