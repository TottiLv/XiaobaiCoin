//
//  AppDelegate.swift
//  XiaobaiCoin
//
//  Created by lvjx on 2021/5/18.
//

import UIKit
import HandyJSON
/*
 https://github.com/JonorZhang/iOSConfuse
 */
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let tabBar: TLMediaCustomTabBar = TLMediaCustomTabBar()
        self.window?.rootViewController = tabBar.XBCustomTabBar()
        
        let adView = TLSplashScreenView.init(.localGif)
        adView.img = "localGIf"
        adView.linkUrl = "https://www.baidu.com/"
        adView.imageValidTime = "09/09/2021 14:00"
        adView.showSplashScreenWithTime(10)
        
        return true
    }
    // MARK: UISceneSession Lifecycle。新建场景，返回场景配置
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }


    //场景关闭时调用
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    //iOS13之前 即将变为非活动状态
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    //iOS13之前，已进入后台
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    //iOS13之前，即将进入前台
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    //iOS13之前，已进入前台，成为活跃进程
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    //iOS13之前，进程终止
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

/*
 
 
 if type == .localImage{
     let adView =  TLSplashScreenView.init(.localImage)
     adView.img = "localImage.JPG"
     adView.linkUrl = "https://www.baidu.com/"
     adView.imageValidTime = "12/12/2021 14:25"
     adView.showSplashScreenWithTime(3)
 }else if type == .localGif{
     let adView = TLSplashScreenView.init(.localGif)
     adView.img = "localGIf"
     adView.linkUrl = "https://www.baidu.com/"
     adView.imageValidTime = "12/12/2021 14:25"
     adView.showSplashScreenWithTime(30)
 }else if type == .localVideo{
     let adView = TLSplashScreenView.init(.localVideo)
     adView.img = "localVidio"
     adView.linkUrl = ""
     adView.imageValidTime = "12/12/2021 14:25"
     adView.videoCycleOnce = false //是否循环
     adView.showSplashScreenWithTime(0)
 }else if type == .netImage{
     let splashScreenManager = TLSplashScreenManager.sharedManager
     if UserDefaults.standard.object(forKey: TLAdImageName) != nil{
         let imageName = UserDefaults.standard.object(forKey: TLAdImageName) as! String
         let filepath = splashScreenManager.getFilePathWithName(imageName)
         let isExist = splashScreenManager.isFileExistWithFilePath(filepath)
         if isExist{
             let adView = TLSplashScreenView.init(.netImage)
             adView.img = filepath
             adView.linkUrl = UserDefaults.standard.object(forKey: TLAdLinkUrl) as? String
             adView.imageValidTime = UserDefaults.standard.object(forKey: TLAdValidTime) as? String
             adView.showSplashScreenWithTime(3)
         }
     }
     splashScreenManager.getAdvertisingData("http://img1.126.net/channel6/2016/022471/0805/2.jpg?dpi=6401136", "12/12/2021 14:25", "https://www.jianshu.com/u/90028000c41d", .netImage)

 }else if type == .netGif{
     let splashScreenManager = TLSplashScreenManager.sharedManager
     if UserDefaults.standard.object(forKey: TLAdGifName) != nil{
         let gifName = UserDefaults.standard.object(forKey: TLAdGifName) as! String
         let filepath = splashScreenManager.getFilePathWithName(gifName)
         let isExist = splashScreenManager.isFileExistWithFilePath(filepath)
         if isExist{
             let adView = TLSplashScreenView.init(.netGif)
             adView.img = filepath
             adView.linkUrl = UserDefaults.standard.object(forKey: TLAdLinkUrl) as? String
             adView.imageValidTime = UserDefaults.standard.object(forKey: TLAdValidTime) as? String
             adView.showSplashScreenWithTime(30)
         }
     }
     splashScreenManager.getAdvertisingData("http://yun.it7090.com/image/XHLaunchAd/pic05.gif", "12/12/2021 14:25", "https://www.jianshu.com/u/90028000c41d", .netGif)
 }else if type == .netVideo{
     let splashScreenManager = TLSplashScreenManager.sharedManager
     if UserDefaults.standard.object(forKey: TLAdVideoName) != nil{
         let vidioName = UserDefaults.standard.object(forKey: TLAdVideoName) as! String
         let filepath = splashScreenManager.getFilePathWithName(vidioName)
         let isExist = splashScreenManager.isFileExistWithFilePath(filepath)
         if isExist{
             let adView = TLSplashScreenView.init(.netVideo)
             adView.img = filepath
             adView.linkUrl = UserDefaults.standard.object(forKey: TLAdLinkUrl) as? String
             adView.imageValidTime = UserDefaults.standard.object(forKey: TLAdValidTime) as? String
             adView.showSplashScreenWithTime(0)
         }
     }
     splashScreenManager.getAdvertisingData("http://yun.it7090.com/video/XHLaunchAd/video03.mp4", "12/12/2021 14:25", "https://www.jianshu.com/u/90028000c41d", .netVideo)
 }

 
 */
