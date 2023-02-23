//
//  InputRowsView.swift
//  MeetCos
//
//  Created by apple on 2023/01/14.
//

import SwiftUI

struct InputRowsView: View {
//    @Binding var personCount: String
//    @Binding var laborCosts: String
//    @Binding var estimatedSalary: String
    
    @State var personCount: String = "0"
    @State var laborCosts: String = "0"
    @State var estimatedSalary: String = "0"
    @State var activeTextField: String?
//    let expense:Expense
    @EnvironmentObject var viewModel: SheetViewModel

    
    var body: some View {
        Section (header: Text("グループ")){
            HStack(alignment: .center) {
                Picker(selection: $personCount) {
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
                TextField("金額を入力",text: $laborCosts)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .onTapGesture {
                        self.activeTextField = "laborCosts"
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
                        if self.activeTextField == "laborCosts" {
                            self.laborCosts = viewModel.returnEmptyStringIfZero(laborCosts)
                        }
                    }
            }
            
            HStack (alignment: .center) {
                Text("売上見込み：")
                    .font(.callout)
                    .bold()
                TextField("金額を入力", text: $estimatedSalary)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .onTapGesture {
                        self.activeTextField = "estimatedSalary"
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
                        if self.activeTextField == "estimatedSalary" {
                            self.estimatedSalary = viewModel.returnEmptyStringIfZero(estimatedSalary)
                        }
                    }
            }
        }.onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
            viewModel.calculateSession()
        }
    }
}

struct InputRowsView_Previews: PreviewProvider {
    @State static var pc = "2"
    @State static var lb = "2"
    @State static var es = "2000"
    @State static var expense = Expense(id: UUID(), personCount: pc, laborCosts: lb, estimatedSales: es)
    
    static var previews: some View {
//        InputRowsView(personCount: .constant("1"), laborCosts: .constant("2"), estimatedSalary: .constant("プレビュー用デフォルトテキスト"))
        InputRowsView()
    }
}

