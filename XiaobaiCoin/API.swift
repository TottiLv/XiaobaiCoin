//
//  API.swift
//  项目API文件
//
//       ###    ########  ####
//      ## ##   ##     ##  ##
//     ##   ##  ##     ##  ##
//    ##     ## ########   ##
//    ######### ##         ##
//    ##     ## ##         ##
//    ##     ## ##        ####
//

import Foundation

/// 实现协议，每个接口，都是一个`APIItem`
struct APIItem: HWAPIProtocol {
    var url: String { API.DOMAIN + URLPath }  // 域名 + path
    let description: String
    let extra: String?
    var method: HWHTTPMethod

    private let URLPath: String  // URL的path

    init(_ path: String, d: String, e: String? = nil, m: HWHTTPMethod = .get) {
        URLPath = path
        description = d
        extra = e
        method = m
    }

    init(_ path: String, m: HWHTTPMethod) {
        self.init(path, d: "", e: nil, m: m)
    }
}

/// App的接口
struct API {
    /// 项目的域名
    static var DOMAIN = "https://api.coindog.com/"

    // MARK: 快讯模块
    struct News {
        static let newsList = APIItem("live/list", d: "快讯列表", m: .get)
    }

    // MARK: 行情模块
    struct Home {
        static let pricesList = APIItem("api/v1/currency/ranks", d: "币值排名")
    }
}

/// 实现协议，每个接口，都是一个`APIItem`
struct CoinAPIItem: HWAPIProtocol {
    var url: String { COINAPI.DOMAIN + URLPath }  // 域名 + path
    let description: String
    let extra: String?
    var method: HWHTTPMethod

    private let URLPath: String  // URL的path

    init(_ path: String, d: String, e: String? = nil, m: HWHTTPMethod = .get) {
        URLPath = path
        description = d
        extra = e
        method = m
    }

    init(_ path: String, m: HWHTTPMethod) {
        self.init(path, d: "", e: nil, m: m)
    }
}

/// App的接口
struct COINAPI {
    /// 项目的域名
    static var DOMAIN = "https://api.fjsp2p.com:10002/"

    // MARK: 快讯模块
    struct AllNet {
        static let netList = CoinAPIItem("v1/news/index", d: "列表", m: .get)
    }
    
}

/**
 可能有人疑问，为什么接口要加一个`description`
 这里解释一下:

 ** 1.在API文件里，能直接明白这接口是做什么的 **
 ** 2.在我项目里，有一个debug隐藏模块，可以看到所有的API请求 **
 ** 3.在debug模块里，不仅后台Java同事能通过`描述`定位接口，测试同事也方便找接口 **

 */
