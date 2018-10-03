import Foundation

public enum NodeType: Equatable {
    case regular
    case wildcard(Bool)
}

public protocol NodeProtocol {
    associatedtype Value
    
    var name: Substring { get }
    var type: NodeType { get }
    
    var info: (pattern: String, value: Value)? { get }
    
    func addChild(name: Substring) throws -> Self
    func getChild(name: Substring) -> Self?
}

// MARK :- Implementation

fileprivate let emptyChar = Character("R")

final public class Node<Value>: NodeProtocol {
    
    public let name: Substring
    public let type: NodeType
    
    public var info: (pattern: String, value: Value)?
    
    var children: [Substring: Node]?
    var wildcardChild: Node?
    
    
    static func make(name: Substring) -> Node {
        switch name.first ?? emptyChar {
        case "*":
            return Node(name: name.dropFirst(), type: .wildcard(true))
        case ":":
            return Node(name: name.dropFirst(), type: .wildcard(false))
        default:
            return Node(name: name, type: .regular)
        }
    }
    
    init(name: Substring, type: NodeType) {
        self.name = name
        self.type = type
    }
    
    public func addChild(name: Substring) throws -> Node {
        let newNode = Node.make(name: name)
        
        switch newNode.type {
        case .regular:
            if children == nil {
                children = [Substring: Node]()
                children?[name] = newNode
            } else if let node = children?[newNode.name] {
                return node
            } else {
                children?[name] = newNode
            }
        case .wildcard:
            if let wildcardChild = wildcardChild {
                if wildcardChild.name != newNode.name {
                    throw RouterError.duplicatedWildcard(String(name))
                }
                return wildcardChild
            }
                
            self.wildcardChild = newNode
        }
        
        return newNode
    }
    
    public func getChild(name: Substring) -> Node? {
        if let node = children?[name] {
            return node
        }
        
        if let node = wildcardChild {
            return node
        }
        
        return nil
    }
}

