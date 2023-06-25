//
//  HomeViewModelTests.swift
//  MeetCosTests
//
//  Created by apple on 2023/06/25.
//

@testable import MeetCos
import XCTest

class HomeViewModelTests: XCTestCase {

    var homeViewModel: HomeViewModel!

    override func setUp() {
        super.setUp()
        let timePickerViewModel = TimePickerViewModel()
        let countdownTimerViewModel = CountdownTimerViewModel(initialDuration: 3600, groups: [])
        homeViewModel = HomeViewModel(timePickerViewModel: timePickerViewModel, countdownTimerViewModel: countdownTimerViewModel)
    }

    override func tearDown() {
        homeViewModel = nil
        super.tearDown()
    }

    func testAppStateChanged() {
        // Initial state (stopped)
        XCTAssertFalse(homeViewModel.countdownTimerViewModel.isTimerActive)

        // Start the timer
        homeViewModel.start()
        XCTAssertTrue(homeViewModel.countdownTimerViewModel.isTimerActive)

        // Simulate app going to background
        homeViewModel.appStateChanged(.background)
        XCTAssertTrue(homeViewModel.countdownTimerViewModel.isTimerActive)

        // Simulate app coming to foreground
        homeViewModel.appStateChanged(.active)
        XCTAssertTrue(homeViewModel.countdownTimerViewModel.isTimerActive)

        // Stop the timer
        homeViewModel.stop()
        XCTAssertFalse(homeViewModel.countdownTimerViewModel.isTimerActive)
    }

    func testTimerCountdownInBackground() {
        // Start the timer with a predefined time
        homeViewModel.timePickerViewModel.hourSelection = 0
        homeViewModel.timePickerViewModel.minSelection = 2
        homeViewModel.updateSessionDuration()
        homeViewModel.start()

        // Capture the remaining time before going to the background
        let remainingTimeBeforeBackground = homeViewModel.countdownTimerViewModel.remainingTime

        // Simulate app going to the background for 2 seconds
        homeViewModel.appStateChanged(.background)
        let expectation = XCTestExpectation(description: "Waiting in background")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)

        // Simulate app coming to the foreground
        homeViewModel.appStateChanged(.active)

        // The remaining time should have decreased by approximately 2 seconds
        let remainingTimeAfterForeground = homeViewModel.countdownTimerViewModel.remainingTime
        XCTAssertLessThan(remainingTimeAfterForeground, remainingTimeBeforeBackground - 1)
    }
}
