//
//  Result.swift
//  App
//
//  Created by Podul on 2018/8/5.
//

import Foundation
import Vapor

protocol Resultable: Content {}

extension Resultable {
    /// 成功
    func success(error: DSError, token: String? = nil) -> Result<Self> {
        return Result(error: error, result: self, token: token)
    }
    /// 失败
    static func failure(_ error: DSError) -> Result<Self> {
        return Result(error: error)
    }
}

struct Result<T>: Content where T: Resultable {
    
    var code: Int
    var result: T?
    var message: String
    var token: String?
    
    init(error: DSError, result: T? = nil, token: String? = nil) {
        self.code = error.code
        self.result = result
        self.message = error.message
        self.token = token
    }
}



/// code 每个模型分 100 个
/// 000000
/// 000100
/// ...
/// 001000
/// 001100
/// ...
/// 缺少参数时code统一为 000001
struct DSError: Content {
    var code: Int
    var message: String
    
    init(code: Int, message: String) {
        self.code = code
        self.message = message
    }
    
    /// 成功
    static func none(_ message: String = "成功") -> DSError {
        return DSError(code: 000000, message: message)
    }
    
    /// 缺少参数
    static func miss(_ message: String = "缺少参数") -> DSError {
        return DSError(code: 000001, message: message)
    }
    
    /// 未知错误
    static let unknow = DSError(code: 000002, message: "未知错误")
}
