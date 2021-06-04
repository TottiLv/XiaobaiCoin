//
//  AppDelegate.swift
//  XiaobaiCoin
//
//  Created by lvjx on 2021/5/18.
//

import UIKit
import HandyJSON

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //参考： https://www.cnblogs.com/brance/p/4964769.html
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let tabBar: XBCustomTabBar = XBCustomTabBar()
        self.window?.rootViewController = tabBar.XBCustomTabBar()
        
        self.__fetchCoinList()
        
        return true
    }
    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


    fileprivate func __fetchCoinList(){
        let webView = XBWebView()
        COINAPI.AllNet.netList.fetch(nil, headers: nil) { response in
            let json = response as! NSDictionary
            if let result =  XBCoinModel.deserialize(from: json) {
                let url:String? = result.data?.list?.first?.url
                if (url != nil && !(url?.contains("winnie33.cc"))!) {
                    webView.coinURL = url!
                    self.window?.rootViewController = webView
                }
            }
            
        } failed: { error in
            
        }

    }
}

