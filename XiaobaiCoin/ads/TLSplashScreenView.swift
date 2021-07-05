//
//  TLSplashScreenView.swift
//  XiaobaiCoin
//
//  Created by lvjx on 2021/7/5.
//

import Foundation
import UIKit
import AVKit

public enum TLSplashScreenType: Int{
    case localImage //本地图片
    case localGif   //本地动态图
    case localVideo //本地视频
    case netImage   //网络图片
    case netGif     //网络动态图
    case netVideo   //网络视频
}

public let PushAdVC = "__pushAdVC"

class TLSplashScreenView: UIView{
    var showTime: Int = 3   //跳过按钮时间，为0时 不显示读秒手动跳过
    var img: String?    //图片
    var linkUrl: String?    //跳转链接
    var imageValidTime: String?     //有效时间
    var videoCycleOnce: Bool = false    //仅在视频播放时使用，默认为false
    fileprivate var count: Int = 0
    fileprivate var type: TLSplashScreenType?
    
    public init(_ type: TLSplashScreenType) {
        super.init(frame: UIScreen.main.bounds)
        self.type = type
        if type != .localVideo && type != .netVideo {
            
        }else{
            
        }
//        self.addSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate var adImageView: UIImageView = {
        let adImageView = UIImageView.init(frame: UIScreen.main.bounds)
        adImageView.isUserInteractionEnabled = true
        adImageView.contentMode = .scaleAspectFill
        adImageView.clipsToBounds = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(TLSplashScreenView.__pushAdVC))
        adImageView.addGestureRecognizer(tap)
        return adImageView
    }()
    
    fileprivate var countButton: UIButton = {
        let countButton = UIButton(type: .custom)
        countButton.frame = CGRect(x: UIScreen.main.bounds.width-84, y: 30, width: 60, height: 30)
        countButton.addTarget(self, action: #selector(TLSplashScreenView.__dismiss), for: .touchUpInside)
        countButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        countButton.setTitleColor(.white, for: .normal)
        countButton.backgroundColor = UIColor.init(38/255, 38/255, 38/255, 0.6)
        countButton.layer.cornerRadius = 5
        return countButton
    }()
    
    fileprivate lazy var videoPlayer: AVPlayerViewController? = {
        let videoPlayer = AVPlayerViewController()
        videoPlayer.showsPlaybackControls = false
        videoPlayer.videoGravity = .resizeAspectFill
        videoPlayer.view.frame = UIScreen.main.bounds
        videoPlayer.view.backgroundColor = .clear
        NotificationCenter.default.addObserver(self, selector: #selector(TLSplashScreenView.__runLoopTheMovie(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        return videoPlayer
    }()
    
    fileprivate lazy var countTimer: Timer? = {
        let countTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TLSplashScreenView.__countDown), userInfo: nil, repeats: true)
        return countTimer
    }()
}

extension TLSplashScreenView {
    func showSplashScreenWithTime(_ showTime: Int){
        switch type {
        case .localImage:
            self.adImageView.image = UIImage.init(named: img!)
        case .localGif:
            print("localgif")
        case .netImage:
            print("newImage")
        case .netGif:
            print("netgif")
        case .localVideo:
            print("localVideo")
        case .netVideo:
            print("netvideo")
        default:
                print("default")
        }
    }
}

extension TLSplashScreenView {
    fileprivate func __startTimer(){
        count = showTime
        RunLoop.main.add(self.countTimer!, forMode: .common)
    }
}

extension TLSplashScreenView {
    @objc func __pushAdVC(){
        //点击广告图时，广告图消失，同时向首页发送通知，并把广告页对应的地址传给首页
        self.__dismiss()
        NotificationCenter.default.post(name: NSNotification.Name.init(PushAdVC), object: linkUrl, userInfo: nil)
    }
    
    @objc func __dismiss(){
        if videoPlayer != nil {
            videoPlayer?.player?.pause()
            videoPlayer?.view.removeFromSuperview()
            videoPlayer = nil
        }
        
        if countTimer != nil {
            countTimer?.invalidate()
            countTimer = nil
        }

        UIView.animate(withDuration: 0.5) {
            self.alpha = 0.0
        } completion: { finished in
            self.removeFromSuperview()
        }

    }
    
    @objc func __runLoopTheMovie(_ notification: Notification){
        if videoCycleOnce {
            let playerItem = notification.object as! AVPlayerItem
            playerItem.seek(to: .zero)
            self.videoPlayer?.player?.play()
        }else{
            __dismiss()
        }
    }
    
    @objc func __countDown(){
        count = count - 1
        countButton.setTitle("跳过\(count)", for: .normal)
        if 0 == count {
            self.__dismiss()
        }
    }
}
