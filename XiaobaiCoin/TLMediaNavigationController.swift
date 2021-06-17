//
//  TLMediaNavigationController.swift
//  XiaobaiCoin
//
//  Created by lvjx on 2021/5/18.
//

import UIKit

class TLMediaNavigationController: UINavigationController{
    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationTitleAttribute: NSDictionary = NSDictionary(object: UIColor.white, forKey: NSAttributedString.Key.foregroundColor as NSCopying)
        self.navigationBar.titleTextAttributes = navigationTitleAttribute as! [AnyHashable: Any] as? [NSAttributedString.Key : Any]
        self.navigationBar.barStyle = .black
        //2.4设置返回按钮颜色
        UINavigationBar.appearance().tintColor = .white
    }
}
