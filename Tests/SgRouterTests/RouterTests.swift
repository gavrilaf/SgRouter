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
        
        tester.assertRouteExists("/", RouterResult.testMake(pattern: "/", value: "/"))
        tester.assertRouteExists("/a", RouterResult.testMake(pattern: "/a", value: "/a"))
        tester.assertRouteExists("/a/b", RouterResult.testMake(pattern: "/a/b", value: "/a/b"))
        tester.assertRouteExists("/a/b/c/d/e/f", RouterResult.testMake(pattern: "/a/b/c/d/e/f", value: "/a/b/c/d/e/f"))
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
        
        tester.assertRouteExists("/id123", RouterResult.testMake(pattern: "/:id", value: "/:id", urlParams: ["id": "id123"]))
        tester.assertRouteExists("/123/send", RouterResult.testMake(pattern: "/:id/:action", value: "/:id/:action", urlParams: ["id": "123", "action": "send"]))
        tester.assertRouteExists("/user/john/do/kill", RouterResult.testMake(pattern: "/user/:id/do/:action", value: "/user/:id/do/:action", urlParams: ["id": "john", "action": "kill"]))
    }


    static var allTests = [
        ("testSimpleRoutes", testSimpleRoutes),
        ("testRouteNotExists", testRouteNotExists),
        ("testUriParams", testUriParams),
    ]
}
