import XCTest
import SgRouter


class UriParserTests: XCTestCase {
    
    func testPathes() {
        UriParser("/").assertUriParsed(expectedPath: [])
        UriParser("/////").assertUriParsed(expectedPath: [])
        UriParser("/user").assertUriParsed(expectedPath: ["user"])
        UriParser("/user").assertUriParsed(expectedPath: ["user"])
        UriParser("/user/").assertUriParsed(expectedPath: ["user"])
        UriParser("/user//").assertUriParsed(expectedPath: ["user"])
        UriParser("/user/profile").assertUriParsed(expectedPath: ["user", "profile"])
        UriParser("/user/profile/:id").assertUriParsed(expectedPath: ["user", "profile", ":id"])
        UriParser("/user/profile/*action").assertUriParsed(expectedPath: ["user", "profile", "*action"])
        UriParser("/user/profile/:id/*action").assertUriParsed(expectedPath: ["user", "profile", ":id", "*action"])
    }
    
    func testQueryParams() {
        UriParser("query?a=10").assertUriParsed(expectedPath: ["query"], expectedQuery: ["a": "10"])
        UriParser("query?a=10&b=").assertUriParsed(expectedPath: ["query"], expectedQuery: ["a": "10", "b": ""])
        UriParser("/user/profile/:id?rewrite=true&verbose=0&level=audit").assertUriParsed(expectedPath: ["user", "profile", ":id"], expectedQuery: ["rewrite": "true", "verbose": "0", "level": "audit"])
    }
    
    func testIterator() {
        let uri = UriParser("/user/profile/vasya/add")
        var expected = ["user", "profile", "vasya", "add"]
        
        for (indx, s) in uri.enumerated() {
            XCTAssertEqual(expected[indx], String(s))
        }
    }
    
    func testPath() {
        let uri = UriParser("src/script.js")
        var it = uri.makeIterator()
        
        XCTAssertEqual("src", it.next())
        XCTAssertEqual("script.js", it.next())
        XCTAssertEqual("script.js", it.remainingPath())
        
        
        let uri2 = UriParser("open/src/script.js")
        var it2 = uri2.makeIterator()
        
        XCTAssertEqual("open", it2.next())
        XCTAssertEqual("src", it2.next())
        XCTAssertEqual("src/script.js", it2.remainingPath())
    }
    
    static var allTests = [
        ("testPathes", testPathes),
        ("testQueryParams", testQueryParams),
        ("testIterator", testIterator),
        ("testPath", testPath),
    ]
}
