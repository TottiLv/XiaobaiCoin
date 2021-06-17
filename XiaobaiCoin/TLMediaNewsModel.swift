//
//  TLMediaNewsModel.swift
//  XiaobaiCoin
//
//  Created by lvjx on 2021/5/19.
//

import Foundation
import HandyJSON


struct TLMediaBaseModel: HandyJSON {
//    required init() {}
}

struct TLMediaNewsContent: HandyJSON{
    var created_at: TimeInterval?
    var content: String?
}

struct TLMediaNewsList: HandyJSON{
    var lives: [TLMediaNewsContent]?
    var date: String?
}

struct TLMediaNewsModel : HandyJSON{
    var news: Int?
    var count: Int?
    var top_id: Int?
    var bottom_id: Int?
    var list: [TLMediaNewsList]?
}
