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
                Picker(selection: Binding($expense.personCount)!) {
                    ForEach(0 ..< 100) { value in
                        Text("\(value)人")
                            .tag("\(value)人")
                    }
                } label: {
                    Text("人数")
                        .font(.callout)
                        .bold()
                }
            }
            
            HStack (alignment: .center) {
                Text("時給：")
                    .font(.callout)
                    .bold()
                TextField("金額を入力",text: Binding($expense.hourlyWage)!)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .onTapGesture {
                        self.activeTextField = "hourlyWage"
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
                        if self.activeTextField == "hourlyWage" {
                            expense.hourlyWage = viewModel.returnEmptyStringIfZero(expense.hourlyWage ?? "0")
                        }
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
                        if self.activeTextField == "hourlyWage" {
                            guard let text = expense.hourlyWage else { return }
                            let filtered = text.filter { "0123456789".contains($0) }
                            if filtered != text {
                                expense.hourlyWage = filtered
                                expense.hourlyWage = viewModel.returnEmptyStringIfZero(expense.hourlyWage ?? "0")
                            }
                            viewModel.changeTotal()
                        }
                    }
            }
            
            HStack (alignment: .center) {
                Text("見込み利益：")
                    .font(.callout)
                    .bold()
                TextField("金額を入力", text: Binding($expense.hourlyProfit)!)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .onTapGesture {
                        self.activeTextField = "hourlyProfit"
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
                        if self.activeTextField == "hourlyProfit" {
                            expense.hourlyProfit = viewModel.returnEmptyStringIfZero(expense.hourlyProfit ?? "0")
                        }
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
                        if self.activeTextField == "hourlyProfit" {
                            guard let text = expense.hourlyProfit else { return }
                            let filtered = text.filter { "0123456789".contains($0) }
                            if filtered != text {
                                expense.hourlyProfit = filtered
                                expense.hourlyProfit = viewModel.returnEmptyStringIfZero(expense.hourlyProfit ?? "0")
                            }
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
    @State static var pc = "2"
    @State static var lb = "2"
    @State static var es = "2000"
    @State static var expense = Expense(id: UUID(), personCount: pc, hourlyWage: lb, hourlyProfit: es)
    
    static var previews: some View {
        InputRowsView(expense: $expense)
    }
}

