import XCTest
import SgRouter

final class SgRouterTests: XCTestCase {
    
    var router: Router<String>!
    var tester: RouterTester!
    
    override func setUp() {
        router = Router<String>()
        tester = RouterTester(router: router)
    }
    
    func testSimpleRoutes() {
        let routes = ["/", "/a", "/a/b", "/a/b/c/d/e/f"]
        
        tester.setup(with: routes)
        
        tester.assertRouteExists("/", RouterResult.testMake(value: "/"))
        tester.assertRouteExists("/a", RouterResult.testMake(value: "/a"))
        tester.assertRouteExists("/a/b", RouterResult.testMake(value: "/a/b"))
        tester.assertRouteExists("/a/b/c/d/e/f", RouterResult.testMake(value: "/a/b/c/d/e/f"))
    }
    
    func testRouteNotExists() {
        let routes = ["/login"]
        
        tester.setup(with: routes)
        
        tester.assertRouteNotExists("/")
        tester.assertRouteNotExists("a")
        tester.assertRouteNotExists("/a/b")
        tester.assertRouteNotExists("/login/user")
    }
    
    func testUriParams() {
        let routes = ["/:id", "/:id/:action", "/user/:id/do/:action"]
        
        tester.setup(with: routes)
        
        tester.assertRouteExists("/id123", RouterResult.testMake(value: "/:id", urlParams: ["id": "id123"]))
        tester.assertRouteExists("/123/send", RouterResult.testMake(value: "/:id/:action", urlParams: ["id": "123", "action": "send"]))
        tester.assertRouteExists("/user/john/do/kill", RouterResult.testMake(value: "/user/:id/do/:action", urlParams: ["id": "john", "action": "kill"]))
    }

    func testQueryParams() {
        let routes = ["/:id", "/user"]
        
        tester.setup(with: routes)
        
        tester.assertRouteExists("/id123?query=123", RouterResult.testMake(value: "/:id", urlParams: ["id": "id123"], queryParams: ["query": "123"]))
        tester.assertRouteExists("/id123?query=", RouterResult.testMake(value: "/:id", urlParams: ["id": "id123"], queryParams: ["query": ""]))
        tester.assertRouteExists("/id123?", RouterResult.testMake(value: "/:id", urlParams: ["id": "id123"], queryParams: [:]))
        tester.assertRouteExists("/user?a=abc&b=", RouterResult.testMake(value: "/user", urlParams: [:], queryParams: ["a": "abc", "b": ""]))
    }
    
    func testPathParams() {
        let routes = ["/src2/*filepath", "/src3/:dir/*filepath", "/src4/*filepath"]
        
        tester.setup(with: routes)
        
        tester.assertRouteExists("/src2/script.js", RouterResult.testMake(value: "/src2/*filepath", urlParams: ["filepath": "script.js"]))
        tester.assertRouteExists("/src2/scripts/script.js", RouterResult.testMake(value: "/src2/*filepath", urlParams: ["filepath": "scripts/script.js"]))
        tester.assertRouteExists("/src3/scripts/script.js", RouterResult.testMake(value: "/src3/:dir/*filepath", urlParams: ["filepath": "script.js", "dir": "scripts"]))
        tester.assertRouteExists("/src3/scripts/js/script.js", RouterResult.testMake(value: "/src3/:dir/*filepath", urlParams: ["filepath": "js/script.js", "dir": "scripts"]))
    }
    
    func testUnicode() {
        let routes = ["/search/:query"]
        
        tester.setup(with: routes)
        
        tester.assertRouteExists("/search/someth!ng+in+ünìcodé", RouterResult.testMake(value: "/search/:query", urlParams: ["query": "someth!ng+in+ünìcodé"]))
    }
    
    static var allTests = [
        ("testSimpleRoutes", testSimpleRoutes),
        ("testRouteNotExists", testRouteNotExists),
        ("testUriParams", testUriParams),
        ("testQueryParams", testQueryParams),
        ("testPathParams", testPathParams),
        ("testUnicode", testUnicode),
    ]
}
