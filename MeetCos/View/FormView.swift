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
    @EnvironmentObject var timePickerViewModel: TimePickerViewModel
    
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
                Section (header: Text("会議時間")){
                    TimePickerView()
                        .environmentObject(timePickerViewModel)
                        .onChange(of: timePickerViewModel.hourSelection) { newValue in
                            timePickerViewModel.hourSelection = newValue
                            viewModel.changeTotal()
                        }
                        .onChange(of: timePickerViewModel.minSelection) { newValue in
                            timePickerViewModel.minSelection = newValue
                            viewModel.changeTotal()
                        }
                }
                ForEach($viewModel.expenses) { $expense in
                    InputRowsView(expense: $expense)
                        .focused(self.$focus)
                }
                
                HStack {
                    Button {
                        if viewModel.expenses.count < 10 {
                            viewModel.expenses.append(Expense(personCount: 0, hourlyWage: 0, hourlyProfit: 0))
                        }
                    } label: {
                        Text("+")
                            .bold()
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.blue)
                    .disabled(viewModel.expenses.count >= 10)
                    
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
                    Text("合計コスト ¥: \(viewModel.totalCost) ").bold()
                }
            }
            Spacer()
        }.gesture(self.gesture)
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        let timePickerVM = TimePickerViewModel()
        let sheetVM = SheetViewModel(timePickerViewModel: timePickerVM)
        
        FormView()
            .environmentObject(sheetVM)
            .environmentObject(timePickerVM)
    }
}
