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
                    Picker(selection: $expense.personCount) { // Update this line
                        ForEach(0 ..< 100) { value in
                            Text("\(value)人")
                                .tag(value) // Update this line to store the 'value' directly as an Int
                        }
                    } label: {
                        Text("人数")
                            .font(.callout)
                            .bold()
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
    @State static var pc = 3
    @State static var lb = 2
    @State static var es = 2000
    @State static var expense = Expense(id: UUID(), personCount: pc, hourlyWage: lb, hourlyProfit: es)
    
    static var previews: some View {
        InputRowsView(expense: $expense)
    }
}

