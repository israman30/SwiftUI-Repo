//
//  DI_with_Unit_Testing_and_CombineUITestsLaunchTests.swift
//  DI with Unit Testing and CombineUITests
//
//  Created by Israel Manzo on 6/25/23.
//

import XCTest

final class DI_with_Unit_Testing_and_CombineUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
