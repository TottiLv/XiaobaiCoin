//
//  XBMeViewController.swift
//  XiaobaiCoin
//
//  Created by lvjx on 2021/6/4.
//

import Foundation

import UIKit
import SnapKit
import OpenCC

let XBJOINURL: String = "https://t.me/BinanceExchange"
let XBPROTOCOLURL: String = "https://docs.google.com/document/d/1q0IwdnBJOP-cGjzHbUg3-d2Z1QVxSkp7XOGcMfOyX64/edit"

class XBMeViewController : UIViewController{
    
    var tableView: UITableView?
    var newsLists: NSMutableArray?
    var converter: ChineseConverter?
    var userName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.converter = try! ChineseConverter(bundle: bundle!, option: [.traditionalize, .TWStandard, .TWIdiom])
        self.navigationItem.title = self.converter?.convert("我的")
        self.view.backgroundColor = .black
        self.newsLists = [(self.converter?.convert("登录/注册"))! as String,(self.converter?.convert("加入社区"))! as String ,(self.converter?.convert("语言"))! as String,(self.converter?.convert("当前版本"))! as String,(self.converter?.convert("用户协议"))! as String]
        
        self.__setupUI()
        self.__layoutUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userName = UserDefaults.standard.value(forKey: "XB_USER_NAME") as? String
        let user:[Substring]? = self.userName?.split(separator: "@")
        if nil != user && user!.count > 1 {
            self.userName = user!.compactMap{"\($0)"}.first
        }
        self.tableView?.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    fileprivate func __setupUI(){
        self.tableView = UITableView(frame: CGRect.zero, style: .plain)
        self.tableView?.separatorStyle = .singleLine//去掉分割线
        self.tableView?.separatorColor = .white
        self.tableView?.backgroundColor = .black
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
//        self.tableView?.estimatedRowHeight = 120
//        self.tableView?.rowHeight = UITableView.automaticDimension
        self.view.addSubview(self.tableView!)
        //注册CELL
        self.tableView?.register(XBNewsTableViewCell.self, forCellReuseIdentifier: "newsCell")
        //清除多余cell分割线
        self.tableView?.tableFooterView = UIView()
    }
    
    fileprivate func __layoutUI(){
        self.tableView?.snp.makeConstraints({ make in
            make.top.equalTo(self.view.snp.top).offset(XBTools.shared.safeArea().top+44)
            make.bottom.equalTo(self.view.snp.bottom).inset(XBTools.shared.safeArea().bottom+44)
            make.left.right.equalTo(self.view)
        })
    }
    
    func confirm() {
        // 建立一個提示框
        let alertController = UIAlertController(
            title: self.converter?.convert("温馨提示"),
            message: self.converter?.convert("确认要退出吗？"),
            preferredStyle: .alert)

        // 建立[取消]按鈕
        let cancelAction = UIAlertAction(
            title: self.converter?.convert("取消"),
            style: .cancel,
          handler: nil)
        alertController.addAction(cancelAction)

        // 建立[送出]按鈕
        let okAction = UIAlertAction(
            title: self.converter?.convert("确认"),
            style: .default) { _ in
            UserDefaults.standard.removeObject(forKey: "XB_USER_NAME")
            UserDefaults.standard.removeObject(forKey: "XB_USER_PWD")
            UserDefaults.standard.synchronize()
            self.userName = nil
            self.tableView?.reloadData()
        }
        alertController.addAction(okAction)

        // 顯示提示框
        self.present(
          alertController,
          animated: true,
          completion: nil)
    }
    
    
    lazy var bundle: Bundle? = {
        let openCCBundle = Bundle(for: ChineseConverter.self)
        guard let resourceUrl = openCCBundle.url(forResource: "OpenCCDictionary", withExtension: "bundle") else {
            return nil
        }
        return Bundle(url: resourceUrl)
    }()
    
}


extension XBMeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsLists?.count ?? 0
    }
    
    //cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identify: String = "newsCell"
        let cell = UITableViewCell(style: .value1, reuseIdentifier: identify)
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .gray
        cell.selectionStyle = .none
        if self.newsLists?.count ?? 0 > indexPath.row {
            let title: String = self.newsLists?.object(at: indexPath.row) as! String
            cell.textLabel?.text = title

            switch indexPath.row {
            case 0:
                self.userName?.append("〉")
                cell.detailTextLabel?.text = self.userName ?? "〉"
                cell.textLabel?.text = self.userName == nil ? title : self.converter?.convert("登出")
            case 1:
                cell.detailTextLabel?.text = "https://t.me/BinanceExchange 〉"
            case 2:
                cell.detailTextLabel?.text = self.converter?.convert("繁体中文")
            case 3:
                let infoDictionary = Bundle.main.infoDictionary!
                let minorVersion = infoDictionary["CFBundleShortVersionString"]
                cell.detailTextLabel?.text = minorVersion as? String
            case 4:
                cell.detailTextLabel?.text = "〉"
            default:
                cell.detailTextLabel?.text = "〉"
            }
        }
        return cell
    }
    
    //返回cell的高度，默认高度是44
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    //cell的点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.hidesBottomBarWhenPushed = true
        switch indexPath.row {
        case 0:
            if (self.userName == nil) {
                let loginVC: XBLoginViewController = XBLoginViewController.init()
                self.navigationController?.pushViewController(loginVC, animated: true)
            }else{
                self.confirm()
            }
            
        case 1:
            let webView = XBWebView()
            webView.coinURL = XBJOINURL
            self.navigationController?.pushViewController(webView, animated: true)
        case 4:
            let webView = XBWebView()
            webView.coinURL = XBPROTOCOLURL
            self.navigationController?.pushViewController(webView, animated: true)
        default:
            print("")
        }
        self.hidesBottomBarWhenPushed = false
    }
}
