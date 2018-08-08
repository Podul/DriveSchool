//
//  User.swift
//  App
//
//  Created by Podul on 2018/8/5.
//

import FluentMySQL
import Vapor
import Authentication

final class User: Content {
    var id: Int?
    var name: String
    var password: String
    
    init(name: String, password: String) {
        self.name = name
        self.password = password
        
    }
    
    final class Public: Content {
        var id: Int?
        var name: String
//        let aaa: DSError = .none()
        init(name: String) {
            self.name = name
        }
    }
}


extension User: Migration {}
extension User: MySQLModel {}
extension User: Parameter {}
extension User: BasicAuthenticatable {
    static let usernameKey: UsernameKey = \User.name
    static let passwordKey: PasswordKey = \User.password
}

//extension User.Public: Content {
//    static let entity = User.entity
//}

extension User.Public: MySQLModel {}

/// 用户 code 为 000100
extension User {
    struct Register {
        let success = DSError.none("注册成功")
        let failed = DSError(code: 000100, message: "注册失败")
        let alreadyExist = DSError(code: 000101, message: "用户已存在")
    }
    
    struct Login {
        let success = DSError.none("登录成功")
        let nonExist = DSError(code: 000102, message: "用户不存在")
        let passwordError = DSError(code: 000103, message: "密码错误")
    }
}

extension DSError {
    static let register = User.Register()
    static let login = User.Login()
}
