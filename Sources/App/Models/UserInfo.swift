//
//  UserInfo.swift
//  App
//
//  Created by Podul on 2018/9/18.
//

import Vapor
import FluentMySQL

struct UserInfo: Resultable {
    var id: Int?
    var userID: User.ID?
    var email: String?
    var nickName: String?
    var age: Int?
    /// 性别 0 未知 1 男 2 女
    var gender: Int?
    
    init(userID: User.ID?) {
        self.userID = userID
    }
}

extension UserInfo: MySQLModel {}
extension UserInfo: Parameter {}
extension UserInfo {
    var user: Parent<UserInfo, User>? {
        return parent(\.userID)
    }
}

extension UserInfo: Migration {
    static func prepare(on connection: MySQLConnection) -> Future<Void> {
            return Database.create(self, on: connection) { builder in
                try addProperties(to: builder)
                builder.reference(from: \.userID, to: \User.id)
//                try builder.addReference(from: \.userID, to: \User.id)
            }
    }
}


extension UserInfo {
    mutating func updateInfo(_ newInfo: UserInfo) {
        if let new = newInfo.email {
            self.email = new
        }
        if let new = newInfo.nickName {
            self.nickName = new
        }
        if let new = newInfo.age {
            self.age = new
        }
        if let new = newInfo.gender {
            self.gender = new
        }
    }
}
