import XCTest
@testable import SgRouter

final class SgRouterTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SgRouter().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
