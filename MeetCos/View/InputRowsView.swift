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
                Text("人件費：")
                    .font(.callout)
                    .bold()
                TextField("金額を入力",text: Binding($expense.laborCosts)!)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .onTapGesture {
                        self.activeTextField = "laborCosts"
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
                        if self.activeTextField == "laborCosts" {
                            expense.laborCosts = viewModel.returnEmptyStringIfZero(expense.laborCosts ?? "0")
                        }
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
                        if self.activeTextField == "laborCosts" {
                            guard let text = expense.laborCosts else { return }
                            let filtered = text.filter { "0123456789".contains($0) }
                            if filtered != text {
                                expense.laborCosts = filtered
                                expense.laborCosts = viewModel.returnEmptyStringIfZero(expense.laborCosts ?? "0")
                            }
                            viewModel.changeTotal()
                        }
                    }
            }
            
            HStack (alignment: .center) {
                Text("売上見込み：")
                    .font(.callout)
                    .bold()
                TextField("金額を入力", text: Binding($expense.estimatedSales)!)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .onTapGesture {
                        self.activeTextField = "estimatedSales"
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
                        if self.activeTextField == "estimatedSales" {
                            expense.estimatedSales = viewModel.returnEmptyStringIfZero(expense.estimatedSales ?? "0")
                        }
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
                        if self.activeTextField == "estimatedSales" {
                            guard let text = expense.estimatedSales else { return }
                            let filtered = text.filter { "0123456789".contains($0) }
                            if filtered != text {
                                expense.estimatedSales = filtered
                                expense.estimatedSales = viewModel.returnEmptyStringIfZero(expense.estimatedSales ?? "0")
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
    @State static var expense = Expense(id: UUID(), personCount: pc, laborCosts: lb, estimatedSales: es)
    
    static var previews: some View {
        InputRowsView(expense: $expense)
    }
}

