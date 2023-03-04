//
//  SheetView.swift
//  MeetCos
//
//  Created by apple on 2023/01/13.
//

import SwiftUI
import CoreData

struct SheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: SheetViewModel
    @Environment(\.managedObjectContext) private var viewContext
    init(container: NSPersistentContainer) {
        let viewModel = SheetViewModel(container: container)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                FormView()
                    .environmentObject(viewModel)
                    .onAppear{
                        viewModel.fetchGroups()
                    }
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
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error loading persistent store: \(error.localizedDescription)")
            }
        }
        return SheetView(container: container)
    }
}
