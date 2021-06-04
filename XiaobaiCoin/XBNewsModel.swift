//
//  XBNewsModel.swift
//  XiaobaiCoin
//
//  Created by lvjx on 2021/5/19.
//

import Foundation
import HandyJSON


struct XBBaseModel: HandyJSON {
//    required init() {}
}

struct XBNewsContent: HandyJSON{
    var created_at: TimeInterval?
    var content: String?
}

struct XBNewsList: HandyJSON{
    var lives: [XBNewsContent]?
    var date: String?
}

struct XBNewsModel : HandyJSON{
    var news: Int?
    var count: Int?
    var top_id: Int?
    var bottom_id: Int?
    var list: [XBNewsList]?
}
