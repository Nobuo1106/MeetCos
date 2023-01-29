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
    @FocusState var focus: Bool
    @ObservedObject var section = Expenses()
    @State private var totalCost = 0
    @State private var numOfInputRows: Int = 3
    
    var gesture: some Gesture {
        DragGesture()
            .onChanged{ value in
                if value.translation.height != 0 {
                    self.focus = false
                }
            }
    }
    
    var body: some View {
        VStack {
            Form {
                ForEach(section.expenses) { item in
                    InputRowsView(expense: item)
                        .focused(self.$focus)
                }
                
                HStack {
                    Button {
                        section.expenses.append(Expense(laborCosts: 0, estimatedSales: 0))
                    } label: {
                        Text("+")
                            .bold()
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.blue)
                    Spacer()
                    Button {
                        section.expenses.removeLast()
                    } label: {
                        Text("-")
                            .bold()
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.red)
                }
                
                Section {
                    Text("総経費 ¥: \(totalCost) ").bold()
                }
            }
            Spacer()
        }.gesture(self.gesture)
    }
}


//extension UIApplication {
//    func closeKeyboard() {
//        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//    }
//}


struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView()
    }
}
