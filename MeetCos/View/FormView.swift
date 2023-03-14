//
//  FormView.swift
//  MeetCos
//
//  Created by apple on 2023/01/13.
//

import SwiftUI

struct FormView: View {
    @FocusState var focus: Bool
    @State private var numOfInputRows: Int = 3
    @EnvironmentObject var viewModel: SheetViewModel
    
    var gesture: some Gesture {
        DragGesture()
            .onChanged{ value in
                if value.translation.height != 0 {
                    viewModel.focus = false
                }
            }
    }
    
    var body: some View {
        VStack {
            Form {
                Section (header: Text("開始時間")){
                    TimePickerView()
                }

                ForEach($viewModel.expenses) { $expense in
                    InputRowsView(expense: $expense)
                    .focused(self.$focus)
                }
                HStack {
                    Button {
                        viewModel.expenses.append(Expense(personCount: "0", hourlyWage: "0", hourlyProfit: "0"))
                    } label: {
                        Text("+")
                            .bold()
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.blue)
                    Spacer()
                    Button {
                        viewModel.expenses.removeLast()
                    } label: {
                        Text("-")
                            .bold()
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(viewModel.expenses.count <= 1 ? .gray : .red)
                    .disabled(viewModel.expenses.count <= 1)
                }

                Section {
                    Text("総経費 ¥: \(viewModel.totalCost) ").bold()
                }
            }
            Spacer()
        }.gesture(self.gesture)
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView()
            .environmentObject(SheetViewModel())
    }
}
