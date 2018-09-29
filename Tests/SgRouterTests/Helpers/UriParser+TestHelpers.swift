import Foundation
import XCTest
import SgRouter

extension UriParser {
    
    func assertUriParsed(expectedPath: [Substring], expectedQuery: [Substring: Substring] = [:], file: StaticString = #file, line: UInt = #line) {
        let path = Array<Substring>(self)
        
        XCTAssertEqual(expectedPath, path, file: file, line: line)
        XCTAssertEqual(expectedQuery, self.queryParams, file: file, line: line)
    }
}
