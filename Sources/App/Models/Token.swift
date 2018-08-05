//
//  Token.swift
//  App
//
//  Created by Podul on 2018/8/5.
//

import Foundation
import Vapor
import FluentMySQL

import Authentication

final class Token: Codable {
    var id: UUID?
    var token: String
    var userID: User.ID
    
    init(token: String, userID: User.ID) {
        self.token = token
        self.userID = userID
    }
}

extension Token: MySQLUUIDModel {}
extension Token: Content {}
extension Token: Migration {}

extension Token {
    var user: Parent<Token, User> {
        return parent(\.userID)
    }
}

import Random
extension Token {
    static func generate(for user: User) throws -> Token {
        let random = OSRandom().generateData(count: 16)
        return try Token(token: random.base64EncodedString(), userID: user.requireID())
    }
}

extension Token: Authentication.Token {
    static let userIDKey: UserIDKey = \Token.userID
    typealias UserType = User
}
extension Token: BearerAuthenticatable {
    static var tokenKey: WritableKeyPath<Token, String> {
        return \.token
    }
    
//    static var tokenKey = \Token.token
}
