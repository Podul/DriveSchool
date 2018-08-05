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
