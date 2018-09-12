import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SgRouterTests.allTests),
        testCase(UriParserTests.allTests),
    ]
}
#endif