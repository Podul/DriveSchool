//
//  HoroscopeController.swift
//  App
//
//  Created by Podul on 2018/11/5.
//
#if !os(Linux)
import Foundation
import Ji
//import Vapor

struct LoveMatch: Content {
    let hor1: String
    let hor2: String
    let content: String
}


struct HoroscopeController: RouteCollection {
    func boot(router: Router) throws {
        let horoscopeGroup = router.grouped("horoscope", "today")
        horoscopeGroup.get(use: today)
    }
    
    func today(_ req: Request) throws -> Future<Response> {
        
        
        
        let url = "https://www.horoscope.com/us/horoscopes/general/horoscope-general-daily-today.aspx?sign=4"
        let doc = Ji(htmlURL: URL(string: url)!)
        let selectNode = doc?.rootNode?.firstChildWithName("body")?.xPath("//select[@name='signlist']").first?.children
        var arr = [String]()
        if let selectNode = selectNode {
            for node in selectNode {
                arr.append((node.content ?? ""))
            }
        }
        arr.removeFirst()
//        print(arr)
        
        
        var contents = [LoveMatch]()
        
        var old = [Int]()
        
        for i in 0...11 {
            for j in 0...11 {
                var isContinue = true
                for str in old {
                    if j == str {
                        isContinue = false
                        break
                    }
                }
                if !isContinue {
                    continue
                }
                
                let url1 = "https://www.horoscope.com/us/games/compatibility/game-love-compatibility.aspx?ZodiacSignSelector_alphastring=\(i)&PartnerZodiacSignSelector_alphastring=\(j)"
//                let url1 = "https://www.horoscope.com/love/compatibility/\(hor)-\(hor1)"
                let doc1 = Ji(htmlURL: URL(string: url1)!)
                let match = doc1?.rootNode?.xPath("//div[@class='span-8 offset-2 span-xs-12 offset-xs-0 col text-center']").first?.firstChild?.content
                
                
                let hor = doc1?.rootNode?.xPath("//main[@role='main']").first?.firstChildWithName("div")?.firstChildWithName("div")?.firstChildWithName("div")?.firstChildWithName("h3")?.content
                
                let hor1 = doc1?.rootNode?.xPath("//main[@role='main']").first?.firstChildWithName("div")?.firstChildWithName("div")?.lastChild?.firstChildWithName("h3")?.content

                contents.append(LoveMatch(hor1: hor ?? "", hor2: hor1 ?? "", content: match ?? ""))
            }
            old.append(i)
        }
        
//        for hor in arr {
//            for hor1 in arr {
//                var isContinue = true
//                for str in old {
//                    if hor1 == str {
//                        isContinue = false
//                        break
//                    }
//                }
//
//                if !isContinue {
//                    continue
//                }
//
//                let url1 = "https://www.horoscope.com/us/games/compatibility/game-love-compatibility.aspx?ZodiacSignSelector_alphastring=]\()&PartnerZodiacSignSelector_alphastring=0"
//                let url1 = "https://www.horoscope.com/love/compatibility/\(hor)-\(hor1)"
//                let doc1 = Ji(htmlURL: URL(string: url1)!)
//                let match = doc1?.rootNode?.xPath("//div[@class='span-8 offset-2 span-xs-12 offset-xs-0 col text-center']").first?.firstChild?.content
//                contents.append(LoveMatch(hor1: hor, hor2: hor1, content: match ?? ""))
//
//            }
//            old.append(hor)
//        }
        print(contents.count)
//        let url1 = "https://www.horoscope.com/love/compatibility/aries-aries"
//        let doc1 = Ji(htmlURL: URL(string: url1)!)
//        let match = doc1?.rootNode?.xPath("//div[@class='span-8 offset-2 span-xs-12 offset-xs-0 col text-center']").first?.firstChild?.content
        
        
        
        return try contents.encode(for: req)
        
        
        
        
//        let jiDoc = Ji(htmlURL: URL(string: "https://www.ganeshaspeaks.com/horoscopes/daily-love-and-relationship-horoscope/cancer/")!)
//        let mainNode = jiDoc?.rootNode?.firstChildWithName("body")?.firstChildWithName("main")
//        let dailyNode = mainNode?.xPath("//div[@id='daily']").first
//
//        let date = dailyNode?.xPath("//p[@class='orrange-text margin-bottom-0 margin-top-5 truncate-line']").first
//        let des = dailyNode?.xPath("//p[@class='margin-top-xs-0']").first
//        print(date?.content ?? "date = NULL")
//        print(des?.content ?? "des = NULL")
//        return try (des?.content ?? "NULL").encode(for: req)
    }
}
#endif
