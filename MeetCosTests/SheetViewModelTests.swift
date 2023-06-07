//
//  MeetCosTests.swift
//  MeetCosTests
//
//  Created by apple on 2023/05/27.
//

import XCTest
@testable import MeetCos

class SheetViewModelTests: XCTestCase {

    var timePickerViewModel: TimePickerViewModel!
    var sheetViewModel: SheetViewModel!

    override func setUp() {
        super.setUp()
        timePickerViewModel = TimePickerViewModel()
        sheetViewModel = SheetViewModel(timePickerViewModel: timePickerViewModel)
    }

    func testCalculateSession() {
        timePickerViewModel.hourSelection = 2
        timePickerViewModel.minSelection = 30
        sheetViewModel.expenses = [
            Expense(personCount: 1, hourlyWage: 2000, hourlyProfit: 1000),
            Expense(personCount: 2, hourlyWage: 3000, hourlyProfit: 5000)
        ]

        let totalCost = sheetViewModel.calculateSession()

        XCTAssertEqual(totalCost, 47500)
    }
}
