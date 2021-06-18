//
//  TLMediaWebView.swift
//  XiaobaiCoin
//
//  Created by lvjx on 2021/5/21.
//

import UIKit
import WebKit
import SnapKit
//https://blog.csdn.net/weixin_41454168/article/details/105264089
class TLMediaWebView: UIViewController,WKNavigationDelegate, WKScriptMessageHandler{
    
    var userWebview: WKWebView?
    var coinURL : String?
    var coinName: String?
//    lazy var loadingView: XBLoadingView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = coinName ?? ""
        let webConfiguration = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        webConfiguration.userContentController = userContentController

        
//        let coinUrl = "http://winnie33.cc/#/detail?currency="+coinType
        let userWebview = WKWebView(frame: CGRect.zero, configuration: webConfiguration)
        userWebview.scrollView.isScrollEnabled = true
        userWebview.scrollView.showsVerticalScrollIndicator = false
        userWebview.scrollView.showsHorizontalScrollIndicator = false
        userWebview.navigationDelegate = self
        self.userWebview = userWebview
        
        self.view .addSubview(self.userWebview!)
        self.__layoutUI()
        
        let myURL = URL(string: coinURL ?? "https://www.sohu.com")
        let myRequest = URLRequest(url: myURL!)
        userWebview.load(myRequest)
    }
    
    lazy var loadingView: TLMediaLoadingView = {
        let loadingView: TLMediaLoadingView = TLMediaLoadingView(frame: CGRect(x: self.view.frame.size.width/2-50, y: self.view.frame.size.height/2-50, width: 100, height: 100))
        loadingView.backgroundColor = UIColor(displayP3Red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 0.3)
        return loadingView
    }()
    
//    self.view.addSubview(loadingView)
    
}

extension TLMediaWebView{
    fileprivate func __layoutUI(){
        self.userWebview?.snp.makeConstraints({ make in
            make.top.equalTo(self.view.snp.top).offset(TLMediaTools.shared.safeArea().top)
            make.bottom.equalTo(self.view.snp.bottom).inset(TLMediaTools.shared.safeArea().bottom)
            make.left.right.equalTo(self.view)
        })
    }
    
    fileprivate func __showLoadingView(){
        self.view.addSubview(self.loadingView)
    }
    
    fileprivate func __removeLoadingView(){
        self.loadingView .removeFromSuperview()
    }
}

extension TLMediaWebView{
    // MARK: --实现WKNavigationDelegate委托协议
        //开始加载时调用
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            self.__showLoadingView()
        }
        
        //当内容开始返回时调用
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            
        }
        
        //加载完成之后调用
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            self.__removeLoadingView()
        }
        
        //加载失败时调用
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("加载失败 error :  ", error.localizedDescription)
            self.__removeLoadingView()
        }
        
        //接收js调用方法
        func userContentController(_ userContentController: WKUserContentController,didReceive message: WKScriptMessage) {
            print("--------"+"\(message.name)")
        }
}
