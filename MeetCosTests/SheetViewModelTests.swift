//
//  MeetCosTests.swift
//  MeetCosTests
//
//  Created by apple on 2023/05/27.
//

@testable import MeetCos
import XCTest

class SheetViewModelTests: XCTestCase {
    var timePickerViewModel: TimePickerViewModel!
    var sheetViewModel: SheetViewModel!

    override func setUp() {
        super.setUp()
        timePickerViewModel = TimePickerViewModel()
        sheetViewModel = SheetViewModel(timePickerViewModel: timePickerViewModel)
    }

    // セッションの合計コストを計算が合っているか確認する
    func testCalculateSession() {
        timePickerViewModel.hourSelection = 2
        timePickerViewModel.minSelection = 30
        sheetViewModel.expenses = [
            Expense(personCount: 1, hourlyWage: 2000, hourlyProfit: 1000),
            Expense(personCount: 2, hourlyWage: 3000, hourlyProfit: 5000),
        ]

        let totalCost = sheetViewModel.calculateSession()

        XCTAssertEqual(totalCost, 47500)
    }

    // グループの順序に誤りがないか確認する
    func testExpenseOrdering() {
        let expense1 = Expense(personCount: 1, hourlyWage: 0, hourlyProfit: 0)
        let expense2 = Expense(personCount: 2, hourlyWage: 0, hourlyProfit: 0)
        let expense3 = Expense(personCount: 3, hourlyWage: 0, hourlyProfit: 0)
        sheetViewModel.expenses = [expense2, expense1, expense3] // initial unordered array
        sheetViewModel.expenses.sort { $0.personCount < $1.personCount }
        let sortedPersonCounts = sheetViewModel.expenses.map { $0.personCount }
        XCTAssertEqual(sortedPersonCounts, [1, 2, 3], "Expenses are not correctly ordered")
    }
}
