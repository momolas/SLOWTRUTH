//
//  LiveDataViewModelTests.swift
//  SMARTOBD2Tests
//
//  Created by Jules on 10/27/23.
//

import XCTest
import SwiftOBD2
@testable import SMARTOBD2

final class LiveDataViewModelTests: XCTestCase {

    var viewModel: LiveDataViewModel!

    override func setUpWithError() throws {
        // Clear UserDefaults before each test to ensure a clean state
        UserDefaults.standard.removeObject(forKey: "pidData")
        viewModel = LiveDataViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        UserDefaults.standard.removeObject(forKey: "pidData")
    }

    func test_LiveDataViewModel_init_withDefaults() {
        // When initialized with no saved data, it should have default PIDs
        XCTAssertEqual(viewModel.pidData.count, 2)
        XCTAssertTrue(viewModel.pidData.contains(where: { $0.command == .mode1(.rpm) }))
        XCTAssertTrue(viewModel.pidData.contains(where: { $0.command == .mode1(.speed) }))
    }

    func test_LiveDataViewModel_addPIDToRequest() {
        // Given
        let initialCount = viewModel.pidData.count
        let newPID = OBDCommand.mode1(.engineLoad)

        // When
        viewModel.addPIDToRequest(newPID)

        // Then
        XCTAssertEqual(viewModel.pidData.count, initialCount + 1)
        XCTAssertTrue(viewModel.pidData.contains(where: { $0.command == newPID }))
    }

    func test_LiveDataViewModel_removePIDToRequest_ifExists() {
        // Given
        let pidToRemove = OBDCommand.mode1(.rpm)
        XCTAssertTrue(viewModel.pidData.contains(where: { $0.command == pidToRemove }))

        // When
        viewModel.addPIDToRequest(pidToRemove)

        // Then
        XCTAssertFalse(viewModel.pidData.contains(where: { $0.command == pidToRemove }))
    }

    func test_LiveDataViewModel_saveDataItems() {
        // Given
        let newPID = OBDCommand.mode1(.coolantTemp)
        viewModel.addPIDToRequest(newPID)
        viewModel.saveDataItems()

        // When
        // Simulate a new session by creating a new ViewModel
        let newViewModel = LiveDataViewModel()

        // Then
        XCTAssertTrue(newViewModel.pidData.contains(where: { $0.command == newPID }))
    }
}
