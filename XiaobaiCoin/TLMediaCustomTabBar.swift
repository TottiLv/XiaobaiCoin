//
//  TLMediaCustomTabBar.swift
//  XiaobaiCoin
//
//  Created by lvjx on 2021/5/18.
//

import UIKit
import OpenCC

class TLMediaCustomTabBar: UITabBarController {
    
    func XBCustomTabBar() -> UITabBarController{
        let homeVC = TLMediaHomeViewController()
        let newsVC = TLMediaNewsViewController()
        let meVC = TLMediaMeViewController()
        
        let homeNavigationController: UINavigationController = TLMediaNavigationController(rootViewController: homeVC)
        let newsNavigationController: UINavigationController = TLMediaNavigationController(rootViewController: newsVC)
        let meNavigationController: UINavigationController = TLMediaNavigationController(rootViewController: meVC)
        
        let tabbarName1 = "资讯"
        let tabbarName2 = "行情"
        let tabbarName3 = "我的"
        let converter = try! ChineseConverter(bundle: bundle!, option: [.traditionalize, .TWStandard, .TWIdiom])
        
        let newsTabbarItem = UITabBarItem(title: converter.convert(tabbarName1), image: UIImage(named: "ib_home"), selectedImage: UIImage(named: "ib_home_selected"))
        let homeTabbarItem = UITabBarItem(title: converter.convert(tabbarName2), image: UIImage(named: "ib_line"), selectedImage: UIImage(named: "ib_line_selected"))
        let meTabbarItem = UITabBarItem(title: converter.convert(tabbarName3), image: UIImage(named: "ib_me"), selectedImage: UIImage(named: "ib_me_selected"))
        
        
        homeNavigationController.tabBarItem = homeTabbarItem
        newsNavigationController.tabBarItem = newsTabbarItem
        meNavigationController.tabBarItem = meTabbarItem
        
        let tabBarVC = UITabBarController()
        tabBarVC.tabBar.tintColor = .white
        tabBarVC.tabBar.barTintColor = .black
        tabBarVC.viewControllers = [newsNavigationController, homeNavigationController, meNavigationController]
        return tabBarVC
    }
    
    lazy var bundle: Bundle? = {
        let openCCBundle = Bundle(for: ChineseConverter.self)
        guard let resourceUrl = openCCBundle.url(forResource: "OpenCCDictionary", withExtension: "bundle") else {
            return nil
        }
        return Bundle(url: resourceUrl)
    }()
}
