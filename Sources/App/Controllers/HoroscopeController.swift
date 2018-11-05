//
//  HoroscopeController.swift
//  App
//
//  Created by Podul on 2018/11/5.
//

import Foundation
import Ji


struct HoroscopeController: RouteCollection {
    func boot(router: Router) throws {
        let horoscopeGroup = router.grouped("horoscope", "today")
        horoscopeGroup.get(use: today)
    }
    
    func today(_ req: Request) throws -> Future<Response> {
        let jiDoc = Ji(htmlURL: URL(string: "https://www.ganeshaspeaks.com/horoscopes/daily-love-and-relationship-horoscope/cancer/")!)
        let mainNode = jiDoc?.rootNode?.firstChildWithName("body")?.firstChildWithName("main")
        let dailyNode = mainNode?.xPath("//div[@id='daily']").first
        
        let date = dailyNode?.xPath("//p[@class='orrange-text margin-bottom-0 margin-top-5 truncate-line']").first
        let des = dailyNode?.xPath("//p[@class='margin-top-xs-0']").first
        print(date?.content ?? "date = NULL")
        print(des?.content ?? "des = NULL")
        return try (des?.content ?? "NULL").encode(for: req)
    }
}
