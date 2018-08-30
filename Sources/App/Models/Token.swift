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

final class Token: Content {
    var id: UUID?
    var tokenString: String
    var userID: User.ID
    var createDate: TimeInterval = Date().timeIntervalSince1970
    
    init(tokenString: String, userID: User.ID) {
        self.tokenString = tokenString
        self.userID = userID
    }
}

extension Token: MySQLUUIDModel {}
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
        return try Token(tokenString: random.base64EncodedString(), userID: user.requireID())
    }
}

extension 

extension Token: Authentication.Token {
    static let userIDKey: UserIDKey = \Token.userID
    typealias UserType = User
}

extension Token: BearerAuthenticatable {
    static var tokenKey: TokenKey = \Token.tokenString
}

