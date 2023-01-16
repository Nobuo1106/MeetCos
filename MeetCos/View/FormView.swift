//
//  FormView.swift
//  MeetCos
//
//  Created by apple on 2023/01/13.
//

import SwiftUI

struct Expense: Identifiable {
    var id = UUID()
    var laborCosts: Int?
    var estimatedSales: Int?
}

class Expenses: ObservableObject {
    @Published var expenses:[Expense] = [Expense(laborCosts: 0, estimatedSales: 0)]
}

struct FormView: View {
    @ObservedObject var section = Expenses()
    @State private var totalCost = 0
    @State private var numOfInputRows: Int = 3
    
    var body: some View {
        Form {
            ForEach(section.expenses) { item in
                InputRowsView(expense: item)
            }
            
            Text("総経費: \(totalCost) ").bold()
        }
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView()
    }
}
