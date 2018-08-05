//
//  User.swift
//  App
//
//  Created by Podul on 2018/8/5.
//

import FluentMySQL
import Vapor
import Authentication

final class User: Codable {
    var id: Int?
    var name: String
    var password: String
    
    init(name: String, password: String) {
        self.name = name
        self.password = password
    }
    
    final class Public: Codable {
        var id: Int?
        var name: String
        init(name: String) {
            self.name = name
        }
    }
}


extension User: Migration {}
extension User: MySQLModel {}
extension User: Content {}
extension User: Parameter {}
extension User: BasicAuthenticatable {
    static let usernameKey: UsernameKey = \User.name
    static let passwordKey: PasswordKey = \User.password
}

extension User.Public: Content {
    static let entity = User.entity
}

extension User.Public: MySQLModel {}

