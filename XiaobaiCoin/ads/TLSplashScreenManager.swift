//
//  TLSplashScreenManager.swift
//  XiaobaiCoin
//
//  Created by lvjx on 2021/7/5.
//

import UIKit

public let TLAdImageName = "AdImageName"
public let TLAdGifName = "AdGifName"
public let TLAdVideoName = "AdVideoName"
public let TLAdLinkUrl = "AdLinkUrl"
public let TLAdValidTime = "AdValidTime"

class TLSplashScreenManager: NSObject {
    public static let sharedManager = TLSplashScreenManager()
    fileprivate override init() {}
    
    func isFileExistWithFilePath(_ filePath: String) -> Bool {
        let fileManager = FileManager.default
        var directory: ObjCBool = ObjCBool(false)
        return fileManager.fileExists(atPath: filePath, isDirectory: &directory)
    }
    
    func getAdvertisingData(_ url: String, _ validTime: String, _ linkUrl: String, _ type: TLSplashScreenType) {
        //获取名称
        let stringArr = url.components(separatedBy: "/")
        let name: String? = stringArr.last
        //拼接沙盒路径
        let filePath: String = getFilePathWithName(name!)
        let isExist: Bool = isFileExistWithFilePath(filePath)
        if !isExist {
            //如果该资源不存在，则删除老的，下载新的
            if type == .netImage {
                downloadAdDataWithUrl(url, name!, linkUrl, validTime, TLAdImageName)
            }else if type == .netGif {
                downloadAdDataWithUrl(url, name!, linkUrl, validTime, TLAdGifName)
            }else if type == .netVideo {
                downloadAdDataWithUrl(url, name!, linkUrl, validTime, TLAdVideoName)
            }
        }
    }
    
    func getFilePathWithName(_ name: String) -> String{
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last
        let filePath: String = paths!.appending(name)
        return filePath
    }
    
    //下载资源到本地
    func downloadAdDataWithUrl(_ url: String , _ name: String, _ linkUrl: String, _ validTime: String, _ key: String){
        DispatchQueue.global().async {
            let data = try? Data.init(contentsOf: URL(string: url)!)
            if nil == data{
                return
            }
            let filePath = self.getFilePathWithName(name)
            let gifData = NSData.init(data: data!)
            let isWrite  = gifData.write(toFile: filePath, atomically: true)
            if isWrite {
                let adImageName: String? = UserDefaults.standard.object(forKey: key) as? String
                if name == adImageName {
                    self.__deleteOldCache()
                }
                UserDefaults.standard.setValue(name, forKey: key)
                UserDefaults.standard.setValue(linkUrl, forKey: TLAdLinkUrl)
                UserDefaults.standard.setValue(validTime, forKey: TLAdValidTime)
                UserDefaults.standard.synchronize()
            }else{
                print("保存失败")
            }
        }
    }
    
    //删除旧的缓存文件
    fileprivate func __deleteOldCache(){
        let imageName: String? = UserDefaults.standard.value(forKey: TLAdImageName) as? String
        let videoName: String? = UserDefaults.standard.value(forKey: TLAdVideoName) as? String
        let gifName: String? = UserDefaults.standard.value(forKey: TLAdGifName) as? String
        
        if nil != imageName {
            let filePath = self.getFilePathWithName(imageName!)
            let fileManager = FileManager.default
            try? fileManager.removeItem(atPath: filePath)
            UserDefaults.standard.setValue("", forKey: TLAdImageName)
            UserDefaults.standard.setValue("", forKey: TLAdLinkUrl)
            UserDefaults.standard.setValue("", forKey: TLAdValidTime)
            UserDefaults.standard.synchronize()
        }
        if nil != gifName {
            let filePath = self.getFilePathWithName(gifName!)
            let fileManager = FileManager.default
            try? fileManager.removeItem(atPath: filePath)
            UserDefaults.standard.setValue("", forKey: TLAdGifName)
            UserDefaults.standard.setValue("", forKey: TLAdLinkUrl)
            UserDefaults.standard.setValue("", forKey: TLAdValidTime)
            UserDefaults.standard.synchronize()
        }
        if nil != videoName {
            let filePath = self.getFilePathWithName(videoName!)
            let fileManager = FileManager.default
            try? fileManager.removeItem(atPath: filePath)
            UserDefaults.standard.setValue("", forKey: TLAdVideoName)
            UserDefaults.standard.setValue("", forKey: TLAdLinkUrl)
            UserDefaults.standard.setValue("", forKey: TLAdValidTime)
            UserDefaults.standard.synchronize()
        }
        
    }
}
