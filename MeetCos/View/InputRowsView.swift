//
//  InputRowsView.swift
//  MeetCos
//
//  Created by apple on 2023/01/14.
//

import SwiftUI

struct InputRowsView: View {
    @State private var personCount: String = "0"
    @State private var laborCost: String = "0"
    @State private var estimatedSalary: String = "0"
    @State private var activeTextField: String?
    @ObservedObject var viewModel = SheetViewModel()
    @EnvironmentObject var timeManager: TimeManager
    
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
                TextField("金額を入力",text: $laborCost)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .onTapGesture {
                        self.activeTextField = "laborCost"
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
                        if self.activeTextField == "laborCost" {
                            self.laborCost = viewModel.returnEmptyStringIfZero(laborCost)
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
    
    static var previews: some View {
        InputRowsView()
    }
}

