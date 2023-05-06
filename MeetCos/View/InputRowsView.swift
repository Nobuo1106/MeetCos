//
//  InputRowsView.swift
//  MeetCos
//
//  Created by apple on 2023/01/14.
//

import SwiftUI

struct InputRowsView: View {
    @Binding var expense: Expense
    @State var activeTextField: String?
    @EnvironmentObject var viewModel: SheetViewModel
    
    var body: some View {
        Section (header: Text("グループ")){
            HStack(alignment: .center) {
                HStack(alignment: .center) {
                    Picker(selection: $expense.personCount) {
                        ForEach(0 ..< 100) { value in
                            Text("\(value)人")
                                .tag(value)
                        }
                    } label: {
                        Text("人数")
                            .font(.callout)
                            .bold()
                    }
                    .onChange(of: expense.personCount) { _ in
                        viewModel.changeTotal()

                    }
                }
            }
            
            HStack (alignment: .center) {
                Text("時給：")
                    .font(.callout)
                    .bold()
                TextField("1XXX", value: $expense.hourlyWage, formatter: NumberFormatterUtility.shared.decimalFormatter)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .onTapGesture {
                        self.activeTextField = "hourlyWage"
                    }

                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
                        if self.activeTextField == "hourlyWage" {
                            viewModel.changeTotal()
                        }
                    }
            }
            
            HStack (alignment: .center) {
                Text("見込み利益：")
                    .font(.callout)
                    .bold()
                TextField("1XXX", value: $expense.hourlyProfit, formatter: NumberFormatterUtility.shared.decimalFormatter)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .onTapGesture {
                        self.activeTextField = "hourlyProfit"
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
                        if self.activeTextField == "hourlyProfit" {
                            viewModel.changeTotal()
                        }
                    }
            }
        }.onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
            viewModel.changeTotal()
        }
    }
}

struct InputRowsView_Previews: PreviewProvider {
    @State static var expense1 = Expense(id: UUID(), personCount: 3, hourlyWage: 2, hourlyProfit: 2000)
    @State static var expense2 = Expense(id: UUID(), personCount: 5, hourlyWage: 3, hourlyProfit: 3000)
    @State static var expense3 = Expense(id: UUID(), personCount: 7, hourlyWage: 4, hourlyProfit: 4000)

    static var previews: some View {
        let timePickerVM = TimePickerViewModel()
        let sheetVM = SheetViewModel(timePickerViewModel: timePickerVM)

        VStack {
            InputRowsView(expense: $expense1)
                .previewDisplayName("Preview 1")
            
            InputRowsView(expense: $expense2)
                .previewDisplayName("Preview 2")
            
            InputRowsView(expense: $expense3)
                .previewDisplayName("Preview 3")
        }.environmentObject(sheetVM)
         .environmentObject(timePickerVM) // Add the environmentObject here
    }
}
