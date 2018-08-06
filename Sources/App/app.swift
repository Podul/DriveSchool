import Vapor

/// Creates an instance of Application. This is called from main.swift in the run target.
public func app(_ env: Environment) throws -> Application {
    var config = Config.default()
    var env = env
    var services = Services.default()
    
    // 改端口等信息
//    #if os(Linux)
//        let con = NIOServerConfig.default(port: 12138)
//        services.register(con)
//    #endif
    let con = NIOServerConfig.loadDefaultConfig()
    services.register(con)
    
    
    try configure(&config, &env, &services)
    let app = try Application(config: config, environment: env, services: services)
    try boot(app)
    return app
}

extension NIOServerConfig {
    static func loadDefaultConfig() -> NIOServerConfig {
        
        struct ServerConfig: Codable {
            var hostname: String?
            var port: Int?
        }
        
        #if os(Linux)
        let path = "/home/project/Private/config.json"
        if let data = FileManager.default.contents(atPath: path) {
            if let config = try? JSONDecoder().decode(ServerConfig.self, from: data) {
                return NIOServerConfig.default(hostname: config.hostname, port: config.port)
            }
        }
        #endif
        return NIOServerConfig.default()
        
    }
}
