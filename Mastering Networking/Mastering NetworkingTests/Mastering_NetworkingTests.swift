//
//  Mastering_NetworkingTests.swift
//  Mastering NetworkingTests
//
//  Created by Israel Manzo on 9/8/23.
//

import XCTest
@testable import Mastering_Networking

final class Mastering_NetworkingTests: XCTestCase {
    
    var coinsViewModel: CoinsViewModel!

    @MainActor override func setUpWithError() throws {
        coinsViewModel = CoinsViewModel()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        coinsViewModel = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchRequestWithNoError() async {
        let expectaion = XCTestExpectation(description: #function)
        let service = CoinDataService()
        expectaion.fulfill()
    }
    
    func testSample() async throws {
        let url = URL(string: "https://google.com")!
        let (_, response) = try await URLSession.shared.data(from: url)
        let httpResponse = try XCTUnwrap(response as? HTTPURLResponse, "Expected a response")
        XCTAssertEqual(httpResponse.statusCode, 200, "Expected 200 status code")
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
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
