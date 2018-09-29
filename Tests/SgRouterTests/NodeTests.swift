import XCTest
@testable import SgRouter

final class NodeTests: XCTestCase {
    
    func testCreateNode() {
        XCTAssertEqual(Node.testMake(name: "", type: .regular), Node<String>.make(name: ""))
        XCTAssertEqual(Node.testMake(name: "aaa", type: .regular), Node<String>.make(name: "aaa"))
        XCTAssertEqual(Node.testMake(name: "id", type: .wildcard(false)), Node<String>.make(name: ":id"))
        XCTAssertEqual(Node.testMake(name: "path", type: .wildcard(true)), Node<String>.make(name: "*path"))
    }


    static var allTests = [
        ("testCreateNode", testCreateNode),
    ]
}
