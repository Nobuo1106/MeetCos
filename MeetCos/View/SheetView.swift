//
//  SheetView.swift
//  MeetCos
//
//  Created by apple on 2023/01/13.
//

import SwiftUI

struct SheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = SheetViewModel()
    @FocusState private var focus: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                FormView()
                    .environmentObject(viewModel)
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
                print("時間\(viewModel.hourSelection)")
                print("分\(viewModel.minSelection)")
            })
        }
    }
}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView()
            .environmentObject(SheetViewModel())
    }
}
