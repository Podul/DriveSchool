//
//  Result.swift
//  App
//
//  Created by Podul on 2018/8/5.
//

import Foundation
import Vapor

struct Result<T>: Codable where T: Codable {
    var errorCode: Int
    var result: T?
    var message: String
    var token: String?
    
    init(errorCode: Int, result: T?, message: String, token: String? = nil) {
        self.errorCode = errorCode
        self.result = result
        self.token = token
        self.message = message
    }
}

extension Result: Content {}

/**
enum DSError {
//    typealias RawValue = Int
    
    // 成功
    // 注册失败
    // 登录失败

    case none               /// 成功
    case alreadyExist       /// 用户已经存在
    case noExist            /// 用户不存在
    case miss               /// 缺少参数
    case token              /// token过期
    case password           /// 密码错误
    
    var code: Int {
        switch self {
        case .none:
            return 0
        case .alreadyExist:
            return 1
        case .miss:
            return 2
        case .token:
            return 3
        case .password:
            return 4
        case .noExist:
            return 5
        }
    }
    
    var message: String {
        switch self {
        case .none:
            return "成功"
        case .alreadyExist:
            return "用户已存在"
        case .noExist:
            return "用户不存在"
        case .miss:
            return "缺少参数"
        case .token:
            return "token过期"
        case .password:
            return "密码错误"
        }
    }

}
*/
