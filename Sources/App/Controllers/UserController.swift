//
//  UserController.swift
//  App
//
//  Created by Podul on 2018/8/5.
//

import Foundation
import Vapor
import Authentication

struct UserController: RouteCollection {
    func boot(router: Router) throws {
        let userGroup = router.grouped("api", "user")
        userGroup.post(User.self, at: "register", use: userRegister)
        userGroup.post(User.self, at: "login", use: userLogin)
//        userGroup.post(User.self, at: "update", use: userUpdate)
    }
    
    /// 用户注册
    func userRegister(_ req: Request, registerUser: User) throws -> Future<Response> {
        return User.query(on: req).filter(\.name == registerUser.name).first().flatMap {
            if let _ = $0 {
                // 用户已存在
//                return try Result<User.Public>(error: DSError.register.alreadyExist).encode(for: req)
                return try User.Public.failure(DSError.register.alreadyExist).encode(for: req)
            }
            let digest = try req.make(BCryptDigest.self)
            registerUser.password = try digest.hash(registerUser.password)
            return registerUser.save(on: req).flatMap { newUser -> Future<Response> in
                let token = try Token.generate(for: newUser)
                let publicInfo = User.Public(user: newUser)
                _ = token.save(on: req)
                // 注册成功
//                return try Result(error: DSError.register.success, result: publicInfo, token: token.token).encode(for: req)
                return try publicInfo.success(error: DSError.register.success, token: token.tokenString).encode(for: req)
            }
        }
    }
    
    /// 用户登录
    func userLogin(_ req: Request, loginUser: User) throws -> Future<Response> {
        return User.query(on: req).filter(\.name == loginUser.name).first().flatMap { user -> Future<Response> in
            guard let user = user else {
                // 用户不存在
                return try Result<User.Public>(error: DSError.login.nonExist, result: nil).encode(for: req)
            }
            let digest = try req.make(BCryptDigest.self)
            if try digest.verify(loginUser.password, created: user.password) {
                // 密码正确
                let publicInfo = User.Public(user: user)
                
//                user.token.query(on: req).
                let token = try Token.generate(for: user)
                _ = token.save(on: req)
                // 登录成功
//                return try Result(error: DSError.login.success, result: publicInfo, token: token.token).encode(for: req)
                return try publicInfo.success(error: DSError.login.success, token: token.tokenString).encode(for: req)
            }else {
                // 密码错误
//                return try Result<User.Public>(error: DSError.login.passwordError).encode(for: req)
                return try User.Public.failure(DSError.login.passwordError).encode(for: req)
            }
        }
    }
    
    /// 用户信息更新
//    func userUpdate(_ req: Request, updateUser: User) throws -> Future<Response> {
//
//    }
}

//extension UserController {
//    // 用户是否存在，不存在返回nil，存在返回用户信息
//    func userIsExist(_ req: Request) throws -> Future<User?> {
//        let userInfo = try req.content.decode(User.self)
//        let aInfo = userInfo.flatMap(to: User?.self) { aUser -> Future<User?> in
//            return User.query(on: req).filter(\.name == aUser.name).all().map { bUser -> User? in
//                return bUser.last
//            }
//        }
//
//        return map(to: User?.self, userInfo, aInfo) { f1, f2 -> User? in
//            if f2 == nil {
//                return f1
//            }
//            return nil
//        }
//    }
//}
