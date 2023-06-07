//
//  InputRowsView.swift
//  MeetCos
//
//  Created by apple on 2023/01/14.
//

import SwiftUI
import UIKit

struct InputRowsView: View {
    @Binding var expense: Expense
    @EnvironmentObject var viewModel: SheetViewModel

    var body: some View {
        Section(header: Text("グループ")) {
            HStack(alignment: .center) {
                Picker(selection: $expense.personCount) {
                    ForEach(0 ..< 100) { value in
                        Text("\(value)人")
                            .tag(value)
                    }
                } label: {
                    Text("人数：")
                        .font(.callout)
                        .bold()
                }
                .onChange(of: expense.personCount) { _ in
                    viewModel.changeTotal()
                }
            }
            HStack {
                VStack(alignment: .leading) {
                    Text("時給：")
                        .font(.callout)
                        .bold()
                        .padding(.bottom)
                    Text("見込み利益：")
                        .font(.callout)
                        .bold()
                }
                Spacer()
                VStack {
                    CurrencyTextField(value: Binding(
                        get: { self.expense.hourlyWage },
                        set: {
                            self.expense.hourlyWage = $0
                            self.viewModel.changeTotal()
                        }
                    ))
                    .padding(.horizontal, 10)
                    .frame(height: 40)
                    .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("Color-4"), lineWidth: 1))

                    CurrencyTextField(value: Binding(
                        get: { self.expense.hourlyProfit },
                        set: {
                            self.expense.hourlyProfit = $0
                            self.viewModel.changeTotal()
                        }
                    ))
                    .padding(.horizontal, 10)
                    .frame(height: 40)
                    .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("Color-4"), lineWidth: 1))
                }
            }
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
            .environmentObject(timePickerVM)
    }
}
