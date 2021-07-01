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

        let newsVC = TLMediaNewsViewController()
        let homeVC = TLMediaHomeViewController()
        let meVC = TLMediaMeViewController()
        
        let newsNavigationController: UINavigationController = TLMediaNavigationController(rootViewController: newsVC)
        newsNavigationController.navigationBar.barTintColor = .white
        newsNavigationController.navigationBar.tintColor = .black
        newsNavigationController.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black]
        let homeNavigationController: UINavigationController = TLMediaNavigationController(rootViewController: homeVC)
        homeNavigationController.navigationBar.barTintColor = .white
        homeNavigationController.navigationBar.tintColor = .black
        homeNavigationController.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black]
        let meNavigationController: UINavigationController = TLMediaNavigationController(rootViewController: meVC)
        meNavigationController.navigationBar.barTintColor = .white
        meNavigationController.navigationBar.tintColor = .black
        meNavigationController.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black]
        
        let tabbarNewsName = "资讯"
        let tabbarHomeName = "行情"
        let tabbarMeName = "我的"
        let converter = try! ChineseConverter(bundle: bundle!, option: [.traditionalize, .TWStandard, .TWIdiom])
        
        let newsTabbarItem = UITabBarItem(title: converter.convert(tabbarNewsName), image: UIImage(named: "ib_home"), selectedImage: UIImage(named: "ib_home_selected"))
        let homeTabbarItem = UITabBarItem(title: converter.convert(tabbarHomeName), image: UIImage(named: "ib_line"), selectedImage: UIImage(named: "ib_line_selected"))
        let meTabbarItem = UITabBarItem(title: converter.convert(tabbarMeName), image: UIImage(named: "ib_me"), selectedImage: UIImage(named: "ib_me_selected"))
        
        newsNavigationController.tabBarItem = newsTabbarItem
        homeNavigationController.tabBarItem = homeTabbarItem
        meNavigationController.tabBarItem = meTabbarItem
        
        let tabBarVC = UITabBarController()
        tabBarVC.tabBar.tintColor = .black
        tabBarVC.tabBar.barTintColor = .white
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
