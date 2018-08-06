import Vapor

/// Creates an instance of Application. This is called from main.swift in the run target.
public func app(_ env: Environment) throws -> Application {
    var config = Config.default()
    var env = env
    var services = Services.default()
    
    // 改端口等信息
    #if os(Linux)
        let con = NIOServerConfig.default(port: 12138)
        services.register(con)
    #endif
    
    
    
    try configure(&config, &env, &services)
    let app = try Application(config: config, environment: env, services: services)
    try boot(app)
    return app
}
