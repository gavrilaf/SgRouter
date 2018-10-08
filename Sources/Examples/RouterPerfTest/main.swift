import SgRouter
import SwiftPerfTool

print("Router performance test")

let routes = [
    "/people/:userId",
    "/people",
    "/activities/:activityId/people/:collection",
    "/people/:userId/people/:collection",
    "/people/:userId/openIdConnect",
    "/people/:userId/activities/:collection",
    "/activities/:activityId",
    "/activities",
    "/activities/:activityId/comments",
    "/comments/:commentId",
    "/people/:userId/moments/:collection",
]

let router = Router<String>()

do {
    try routes.forEach { try router.add(relativePath: $0, value: $0) }
    
    let trials: [() -> Void] = [
        { _ = try? router.lookup(uri: "/people/john") },
        { _ = try? router.lookup(uri: "/activities") },
        { _ = try? router.lookup(uri: "/people/john/moments/photos") },
        { _ = try? router.lookup(uri: "/comments/123456") },
    ]
    
    let config = SPTConfig(iterations: 5000, trials: trials)
    
    let rs = runMeasure(with: config)
    
    print("SgRouter performance\n\(rs)")
} catch let e {
    print("Failed with error: \(e)")
}
