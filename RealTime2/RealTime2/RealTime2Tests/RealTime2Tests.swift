//
//  RealTime2Tests.swift
//  RealTime2Tests
//
//  Created by Alex Rhodes on 11/2/23.
//

import XCTest
@testable import RealTime2

final class RealTime2Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGaugeValuesAppending() {
        // Set up the initial conditions
        let bluetoothDataHandler = BluetoothDataHandler()
        bluetoothDataHandler.receivedData = ["10", "20", "30"]
        var gauge1Values: [Double] = []

        // Execute the code snippet
        if !bluetoothDataHandler.receivedData.isEmpty {
            let newData = bluetoothDataHandler.receivedData.map { Double($0) ?? 0.0 }
            gauge1Values.append(newData[0])
        }

        // Assert the expected behavior
        XCTAssertEqual(gauge1Values, [10.0], "Unexpected gauge1Values")
    }

}
