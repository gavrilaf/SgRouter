import Foundation

public struct UriParser {
    static let questionMark = Character("?")
    static let amp = Character("&")
    static let eq = Character("=")

    public let uri: String
    public let queryParams: [Substring: Substring]
    
    public init(_ uri: String) {
        self.uri = uri
        
        if let end = uri.index(of: UriParser.questionMark) {
            self.pathEndIndex = end
            self.queryParams = UriParser.parseQuery(uri[uri.index(after: end)...])
        } else {
            self.pathEndIndex = uri.endIndex
            self.queryParams = [:]
        }
    }
    
    // MARK:- private
    private let pathEndIndex: String.Index
    
    private static func parseQuery(_ s: Substring) -> [Substring: Substring] {
        let params = s.split(separator: UriParser.amp)
        
        var res = [Substring: Substring]()
        params.forEach {
            let pp = $0.split(separator: UriParser.eq)
            if pp.count == 1 {
                res[pp[0]] = ""
            } else if pp.count > 1 {
                res[pp[0]] = pp[1]
            }
        }
        return res
    }
}

extension UriParser: Sequence {
    public func makeIterator() -> UriIterator {
        return UriIterator(uri: uri[Range(uncheckedBounds: (lower: uri.startIndex, upper: pathEndIndex))])
    }
} 

// MARK:- 
public struct UriIterator: IteratorProtocol {
    static let slash = Character("/")
    
    public init(uri: Substring) {
        self.uri = uri
        self.currentPos = uri.startIndex
        self.previousPos = self.currentPos
    }
    
    public mutating func next() -> Substring? {
        while true {
            guard currentPos < uri.endIndex else { return nil }
            
            let substr = uri[Range(uncheckedBounds: (lower: currentPos, upper: uri.endIndex))]
            if let nextIndex = substr.index(of: UriIterator.slash) {
                let dist = substr.distance(from: substr.startIndex, to: nextIndex)
                let convertedIndex = uri.index(currentPos, offsetBy: dist)
                let result = uri[Range(uncheckedBounds: (lower: currentPos, upper: convertedIndex))]
                
                previousPos = currentPos
                currentPos = uri.index(after: convertedIndex)
                
                if result.isEmpty {
                    continue
                }
                
                return result
            } else {
                previousPos = currentPos
                currentPos = uri.endIndex
                return substr
            }
        }
    }
    
    public func remainingPath() -> Substring {
        return uri[Range(uncheckedBounds: (lower: previousPos, upper: uri.endIndex))]
    }
    
    // MARK:- private
    private let uri: Substring
    private var currentPos: String.Index
    private var previousPos: String.Index
}
