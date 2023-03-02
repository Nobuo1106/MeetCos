//
//  Expense.swift
//  MeetCos
//
//  Created by apple on 2023/02/23.
//

import Foundation

struct Expense: Identifiable {
    var id = UUID()
    var personCount: String?
    var hourlyWage: String?
    var hourlyProfit: String?
}

