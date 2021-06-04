//
//  XBHomeMode.swift
//  XiaobaiCoin
//
//  Created by lvjx on 2021/5/20.
//

import Foundation
import HandyJSON


struct XBHomeMode : HandyJSON{
    var currency: String?
    var name: String?
    var iconUrl: String?
    var marketCap: Double?  // 总市值
    var price: Double?  // 价格
    var change: Double? // 涨跌幅
}

