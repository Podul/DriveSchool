//
//  WebController.swift
//  App
//
//  Created by Podul on 2018/8/7.
//

import Vapor
import Leaf

struct WebController: RouteCollection {
    func boot(router: Router) throws {
//        router.get(use: index)
    }
    
    func index(_ req: Request) throws -> Future<View> {
//        "/Users/podul/Downloads/index.html"
        return try req.view().render("/home/wwwroot/default/index")
    }
}
