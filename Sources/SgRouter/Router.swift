import Foundation

public struct RouterResult<T> {
    public let pattern: String
    public let value: T
    public let urlParams: [Substring: Substring]
    public let queryParams: [Substring: Substring]
    
    public init(pattern: String, value: T, urlParams: [Substring: Substring], queryParams: [Substring: Substring]) {
        self.pattern = pattern
        self.value = value
        self.urlParams = urlParams
        self.queryParams = queryParams
    }
}

extension RouterResult: CustomStringConvertible {
    public var description: String {
        return "RouterResult(\(pattern), \(value), \(urlParams), \(queryParams))"
    }
}

// MARK:-
public protocol RouterProtocol {
    associatedtype Value
    
    func add(relativePath: String, value: Value) throws
    func lookup(uri: String) throws -> RouterResult<Value>
}


// MARK:-
public final class Router<Value>: RouterProtocol {
    
    public init() {
        root = Node.make(name: "")
    }
    
    public func add(relativePath: String, value: Value) throws {
        var current = root
        let parsedUri = UriParser(relativePath)
        
        for s in parsedUri {
            current = try current.addChild(name: s)
        }
        
        current.leaf = (pattern: relativePath, value: value)
    }
    
    public func lookup(uri: String) throws -> RouterResult<Value> {
        var current = root
        var urlParams = [Substring: Substring]()
        
        let parsedUri = UriParser(uri)
        
        var it = parsedUri.makeIterator()
        outer: while let s = it.next() {
            guard let node = current.getChild(name: s) else {
                throw RouterError.notFound(uri)
            }
            
            switch node.type {
            case .regular:
                current = node
            case .wildcard(let capturePath):
                if capturePath {
                    urlParams[node.name] = it.remainingPath()
                    current = node
                    break outer
                } else {
                    urlParams[node.name] = s
                    current = node
                }
            }
        }
        
        if let leaf = current.leaf {
            return RouterResult(pattern: leaf.pattern, value: leaf.value, urlParams: urlParams, queryParams: parsedUri.queryParams)
        }
        
        throw RouterError.notFound(uri)
    }
    
    var root: Node<Value>
}
