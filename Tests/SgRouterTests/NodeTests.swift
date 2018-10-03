import XCTest
@testable import SgRouter

final class NodeTests: XCTestCase {
    
    func testCreateNode() {
        XCTAssertEqual(Node.testMake(name: "", type: .regular), Node<String>.make(name: ""))
        XCTAssertEqual(Node.testMake(name: "aaa", type: .regular), Node<String>.make(name: "aaa"))
        XCTAssertEqual(Node.testMake(name: "id", type: .wildcard(false)), Node<String>.make(name: ":id"))
        XCTAssertEqual(Node.testMake(name: "path", type: .wildcard(true)), Node<String>.make(name: "*path"))
    }

    func testAddChildAndGet() {
        let root = Node<String>.make(name: "")
        
        let first = try? root.addChild(name: "first")
        let second = try? root.addChild(name: "second")
        
        XCTAssertEqual("first", first?.name)
        XCTAssertEqual(NodeType.regular, first?.type)
        
        XCTAssertEqual(first, root.getChild(name: "first"))
        XCTAssertEqual(second, root.getChild(name: "second"))
    }
    
    func testWildcard() {
        let root = Node<String>.make(name: "")
        
        let first = try? root.addChild(name: ":id")
        
        XCTAssertEqual("id", first?.name)
        XCTAssertEqual(NodeType.wildcard(false), first?.type)
        
        XCTAssertThrowsError(try root.addChild(name: ":user"), expectedError: RouterError.duplicatedWildcard(":user"))
        
        let second: Node<String>? = first.flatMap { try? $0.addChild(name: "*path") }
        XCTAssertEqual("path", second?.name)
        XCTAssertEqual(NodeType.wildcard(true), second?.type)
    }

    static var allTests = [
        ("testCreateNode", testCreateNode),
        ("testAddChildAndGet", testAddChildAndGet),
        ("testWildcard", testWildcard),
    ]
}
