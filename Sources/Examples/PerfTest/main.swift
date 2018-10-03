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
    
    
    
} catch let e {
    print("Failed with error: \(e)")
}
