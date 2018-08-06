import FluentMySQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentMySQLProvider())

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a SQLite database

    /// Register the configured SQLite database to the database config.
//    let mysqlConfig = MySQLDatabaseConfig(username: "root", password: "***", database: "DriveSchool", transport: .unverifiedTLS)
    let mysqlConfig = MySQLDatabaseConfig.loadDefaultConfig(env)
    let mysql = MySQLDatabase(config: mysqlConfig)
    var databases = DatabasesConfig()
    databases.add(database: mysql, as: .mysql)
    
    services.register(databases)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .mysql)
    migrations.add(model: Token.self, database: .mysql)
    services.register(migrations)

}


extension MySQLDatabaseConfig {
    
    struct Base: Content {
        var hostname: String
        var username: String
        var password: String
        var port: Int?
    }
    
    static func loadDefaultConfig(_ env: Environment) -> MySQLDatabaseConfig {
        let name = env.isRelease ? "DriveSchool" : "DriveSchoolDebug"
        
        var hostname = "localhost"
        var username = "vapor"
        var password = "******"
        var port = 3306
        
        #if os(Linux)
        let path = "/home/project/Private/base.json"
        #else
        let path = "/Users/podul/Desktop/Vapor/DriveSchool/Public/base.json"
        #endif
        
        if let data = FileManager.default.contents(atPath: path) {
            if let base = try? JSONDecoder().decode(Base.self, from: data) {
                hostname = base.hostname
                username = base.username
                password = base.password
                port = base.port ?? 3306
            }else {
                PrintLogger().warning("读取失败")
            }
        }
        
        return MySQLDatabaseConfig(hostname: hostname, port: port, username: username, password: password, database: name)
    }
}

