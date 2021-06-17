//
//  TLMediaCoinModel.swift
//  XiaobaiCoin
//
//  Created by lvjx on 2021/6/2.
//
import HandyJSON

struct TLMediaCoinDataDetailModel: HandyJSON {
    var summary: String?
    var thumbnail: String?
    var createTime: TimeInterval?
    var publishedTime: String?
    var author: String?
    var id: Int?
    var platformId: String?
    var title: String?
    var content:String?
    var url: String?
}

struct TLMediaCoinDataModel: HandyJSON {
    var total: Int?
    var list:[TLMediaCoinDataDetailModel]?
}

struct TLMediaCoinModel : HandyJSON{
//    var code: Int?
//    var msg: String?
//    var data: [XBCoinDataModel]?
    
    var code: Int?
    var msg: String?
    var pageNum: Int?
    var pageSize: Int?
    var size: Int?
    var startRow: Int?
    var endRow: Int?
    var pages: Int?
    var prePage: Int?
    var nextPage: Int?
    var isFirstPage: Bool?
    var isLastPage: Bool?
    var hasPreviousPage: Bool?
    var hasNextPage: Bool?
    var navigatePages: Int?
    var navigateFirstPage: Int?
    var navigateLastPage: Int?
    var lastPage: Int?
    var firstPage: Int?
    var navigatepageNums: [Int]?
    var data: TLMediaCoinDataModel?
    
}
