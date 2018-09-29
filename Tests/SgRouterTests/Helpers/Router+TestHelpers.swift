import Foundation
import XCTest
import SgRouter


// MARK :-

extension RouterResult where T == String {
    static func testMake(pattern: String = "", value: String, urlParams: [Substring: Substring] = [:], queryParams: [Substring: Substring] = [:]) -> RouterResult<T> {
        return RouterResult(pattern: pattern, value: value, urlParams: urlParams, queryParams: queryParams)
    }
}

extension RouterResult: Equatable where T: Equatable {
    public static func == (lhs: RouterResult<T>, rhs: RouterResult<T>) -> Bool {
        return lhs.pattern == rhs.pattern && lhs.value == rhs.value && lhs.urlParams == rhs.urlParams && lhs.queryParams == rhs.queryParams
    }
}

// MARK :-

struct RouterTester {
    let router: Router<String>
    
    init(router: Router<String>) {
        self.router = router
    }
    
    func setup(with routes: [String], file: StaticString = #file, line: UInt = #line) {
        XCTAssertNoThrow(try routes.forEach { try self.router.add(relativePath: $0, value: $0) }, file: file, line: line)
    }
    
    func assertRouteExists(_ uri: String, _ expected: RouterResult<String>, file: StaticString = #file, line: UInt = #line) {
        let p = try? router.lookup(uri: uri)
        
        XCTAssertNotNil(p, "Route for \(uri) not found", file: file, line: line)
        XCTAssertEqual(expected, p, file: file, line: line)
    }
    
    func assertRouteNotExists(_ uri: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertThrowsError(try self.router.lookup(uri: uri), expectedError: RouterError.notFound(uri), "Route \(uri) should not be found", file: file, line: line)
    }
}
