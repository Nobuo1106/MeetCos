//
//  InputRowsView.swift
//  MeetCos
//
//  Created by apple on 2023/01/14.
//

import SwiftUI

struct InputRowsView: View {
    @State private var personCount: String = "0"
    @State private var laborCost: Int?
    @State private var amount: Int?
    @State var expense: Expense
    
    var body: some View {
        Section {
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
                TextField("金額を入力", value: $expense.laborCosts, format: .currency(code: "JPY"))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
            }
            
            HStack (alignment: .center) {
                Text("売上見込み：")
                    .font(.callout)
                    .bold()
                TextField("金額を入力", value: $expense.estimatedSales, format: .currency(code: "JPY"))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
            }
        }
    }
}

struct InputRowsView_Previews: PreviewProvider {
    
    static var previews: some View {
        InputRowsView(expense: Expense(id: UUID()))
    }
}
