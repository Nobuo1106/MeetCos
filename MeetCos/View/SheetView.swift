//
//  SheetView.swift
//  MeetCos
//
//  Created by apple on 2023/01/13.
//

import CoreData
import SwiftUI

struct SheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: SheetViewModel
    @StateObject var timePickerViewModel = TimePickerViewModel()
    init(latestSession _: Session? = nil) {
        let timePickerVM = TimePickerViewModel()
        let viewModel = SheetViewModel(timePickerViewModel: timePickerVM)
        _timePickerViewModel = StateObject(wrappedValue: timePickerVM)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            VStack {
                FormView()
                    .environmentObject(viewModel)
                    .environmentObject(timePickerViewModel)
            }
            .onAppear {
                viewModel.getLatestGroups()
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Button("閉じる") {
                            viewModel.focus = false
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                        .disabled(viewModel.focus)
                        .keyboardShortcut(.defaultAction)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .navigationBarItems(leading: Button("キャンセル") {
                presentationMode.wrappedValue.dismiss()
            })
            .navigationBarItems(trailing: Button("完了") {
                presentationMode.wrappedValue.dismiss()
                viewModel.saveSessionAndGroups()
            })
        }.accentColor(.green)
    }
}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error loading persistent store: \(error.localizedDescription)")
            }
        }
        return SheetView()
    }
}
