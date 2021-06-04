//
//  XBTools.swift
//  XiaobaiCoin
//
//  Created by lvjx on 2021/5/20.
//

import Foundation
import UIKit
class XBTools {
    
    static let shared = XBTools()
    
    private init(){}
    
    //日期 -> 字符串
    func date2String(_ date:Date, dateFormat:String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date
    }
 
    func safeArea() -> UIEdgeInsets{
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow!.safeAreaInsets
        } else {
            // Fallback on earlier versions
            return UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 0)
        }
    }
}
