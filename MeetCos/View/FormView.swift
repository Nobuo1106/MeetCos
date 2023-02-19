//
//  FormView.swift
//  MeetCos
//
//  Created by apple on 2023/01/13.
//

import SwiftUI

struct FormView: View {
    @FocusState var focus: Bool
    @ObservedObject var section = Expenses()
    @State private var totalCost = 0
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

                ForEach(section.expenses) { item in
                    InputRowsView()
                        .focused(self.$focus)
                }
//
                HStack {
                    Button {
                        section.expenses.append(Expense(personNum: 0, laborCosts: 0, estimatedSales: 0))
                    } label: {
                        Text("+")
                            .bold()
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.blue)
                    Spacer()
                    Button {
                        section.expenses.removeLast()
                    } label: {
                        Text("-")
                            .bold()
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(section.expenses.count <= 1 ? .gray : .red)
                    .disabled(section.expenses.count <= 1)
                }
                
                Section {
                    Text("総経費 ¥: \(totalCost) ").bold()
                }
            }
            Spacer()
        }.gesture(self.gesture)
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView()
    }
}
