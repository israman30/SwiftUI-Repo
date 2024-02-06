//
//  UIToastTest.swift
//  UIToastTest
//
//  Created by Israel Manzo on 1/29/24.
//

import XCTest

final class UIToastTest: XCTestCase {
    
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-ui-testing"]
        app.launchEnvironment = [:]
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        
        

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func test_ToastMessage() {
        let eventButton = app.buttons["Event"]
        XCTAssert(eventButton.exists)
        
        eventButton.tap()
        
        let toast = app.staticTexts["Toast_Text"]
        XCTAssert(toast.exists)
        
        XCTAssertTrue(eventButton.waitForExistence(timeout: 1.0))
    }
    
    
    

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
