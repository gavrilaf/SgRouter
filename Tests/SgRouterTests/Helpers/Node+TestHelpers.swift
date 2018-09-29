import Foundation
import XCTest
@testable import SgRouter

extension Node where Value == String {
    static func testMake(name: Substring, type: NodeType, children: [Substring: Node]? = nil, wildcardChild: Node? = nil) -> Node {
        let node = Node(name: name, type: type)
        node.children = children
        node.wildcardChild = wildcardChild
        return node
    }
}

extension Node: Equatable where Value: Equatable {
    public static func == (lhs: Node, rhs: Node) -> Bool {
        let childrenEqual: Bool = (lhs.children == rhs.children)
        let wildcardEqual = (lhs.wildcardChild == rhs.wildcardChild)
        return lhs.name == rhs.name && lhs.type == rhs.type && childrenEqual && wildcardEqual
    }
}
