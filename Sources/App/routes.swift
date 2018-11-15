import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
//    router.get("") { req in
//        return "Hello, world!"
//    }
//    router.post("") { req in
//        return "Hello, world!"
//    }

    // Example of configuring a controller
    #if !os(Linux)
    try router.register(collection: HoroscopeController())
    #endif
    try router.register(collection: UserController())
    try router.register(collection: WebController())
}
