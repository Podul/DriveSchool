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
        userGroup.post("login", use: userLogin)
    }
    
    func userRegister(_ req: Request, newUser: User) throws -> Future<Response> {
        let aUser = User.query(on: req).filter(\.name == newUser.name).first()
        return aUser.flatMap { oldUser -> Future<Response> in
            if oldUser != nil {
                return try Result<User.Public>(errorCode: 2, result: nil, message: "用户已存在").encode(for: req)
            }
            
            let digest = try req.make(BCryptDigest.self)
            newUser.password = try digest.hash(newUser.password)
            return newUser.save(on: req).flatMap { newInfo -> Future<Response> in
                let token = try Token.generate(for: newInfo)
                let userPublic = User.Public(name: newInfo.name)
                userPublic.id = newInfo.id
                _ = token.save(on: req)
                return try Result<User.Public>(errorCode: 0, result: userPublic, message: "注册成功", token: token.token).encode(for: req)
            }
        }
    }
    
    func userLogin(_ req: Request) throws -> Future<Result<User.Public>> {
        let result = try req.content.decode(User.self).flatMap { info -> Future<Result<User.Public>> in
            // 查找数据库是否有该用户
            let queryUserInfo = User.query(on: req).filter(\.name == info.name).all().map(to: Result<User.Public>.self) { users -> Result<User.Public> in
                // 不存在，登录失败
                if users.count == 0 {
                    return Result(errorCode: 1, result: nil, message: "用户不存在")
                }
                // 存在，进行密码验证
                let aUser = users.first!
                let digest = try req.make(BCryptDigest.self)
                
                print(info.password)
                
                if try digest.verify(info.password, created: aUser.password) {
                    // 密码正确
                    let publicUser = User.Public(name: aUser.name)
                    publicUser.id = aUser.id
                    let token = try Token.generate(for: aUser)
                    _ = token.save(on: req)
                    return Result(errorCode: 0, result: publicUser, message: "登录成功", token: token.token)
                }else {
                    // 密码错误
                    return Result(errorCode: 1, result: nil, message: "密码错误")
                }
            }
            return queryUserInfo
        }
        return result
    }
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
