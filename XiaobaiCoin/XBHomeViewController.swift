//
//  XBHomeViewController.swift
//  XiaobaiCoin
//
//  Created by lvjx on 2021/5/18.
//

import UIKit
import SnapKit
import HandyJSON
import ESPullToRefresh
import OpenCC

class XBHomeViewController : UIViewController{
    
    var tableView: UITableView?
    var coinsList: NSMutableArray?
    var converter: ChineseConverter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.converter = try! ChineseConverter(bundle: bundle!, option: [.traditionalize, .TWStandard, .TWIdiom])
        self.navigationItem.title = self.converter?.convert("行情")
        self.view.backgroundColor = .black
        self.coinsList = NSMutableArray.init()
        
        self.__setupUI()
        self.__layoutUI()
        self.__fetchCoinValueList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    fileprivate func __setupUI(){
        self.tableView = UITableView(frame: CGRect.zero, style: .plain)
        self.tableView?.separatorStyle = .none//去掉分割线
        self.tableView?.backgroundColor = .black
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.view.addSubview(self.tableView!)
        
        //注册CELL
        self.tableView?.register(XBHomeTableViewCell.self, forCellReuseIdentifier: "homeCell")
        //清除多余cell分割线
        self.tableView?.tableFooterView = UIView()
        
        //下拉刷新
        self.tableView?.es.addPullToRefresh {
            [weak self] in
            self?.coinsList?.removeAllObjects()
            self?.__fetchCoinValueList()
            self?.tableView?.es.stopPullToRefresh()
        }
    }
    
    fileprivate func __layoutUI(){
        self.tableView?.snp.makeConstraints({ make in
            make.top.equalTo(self.view.snp.top).offset(XBTools.shared.safeArea().top+44)
            make.bottom.equalTo(self.view.snp.bottom).inset(XBTools.shared.safeArea().bottom+44)
            make.left.right.equalTo(self.view)
        })
    }
    
    fileprivate func __fetchCoinValueList(){
        API.Home.pricesList.fetch { response in
            let json = response as! NSArray
            if let result = JSONDeserializer<XBHomeMode>.deserializeModelArrayFrom(array: json) {
                self.coinsList?.addObjects(from: result as [Any])
                self.tableView?.reloadData()
            }
        } failed: { error in
            
        }

    }
    
    fileprivate func hideTabBar(){
//        if self.tabBarController?.tabBar.isHidden == true {
//            return
//        }
        
    }
    
    lazy var bundle: Bundle? = {
        let openCCBundle = Bundle(for: ChineseConverter.self)
        guard let resourceUrl = openCCBundle.url(forResource: "OpenCCDictionary", withExtension: "bundle") else {
            return nil
        }
        return Bundle(url: resourceUrl)
    }()
}

extension XBHomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    
    
    //行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coinsList?.count ?? 0
    }
    
    //cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identify: String = "homeCell"
        let cell = XBHomeTableViewCell(style: .default, reuseIdentifier: identify)
        cell.selectionStyle = .none
        if self.coinsList?.count ?? 0 > indexPath.row {
            let model: XBHomeMode = self.coinsList?.object(at: indexPath.row) as! XBHomeMode
            cell.setValueForCell(model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    //返回cell的高度，默认高度是44
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    //cell的点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webView = XBWebView()
        if self.coinsList?.count ?? 0 > indexPath.row {
            let model: XBHomeMode = self.coinsList?.object(at: indexPath.row) as! XBHomeMode
            webView.coinURL = "http://winnie33.cc/#/detail?currency="+model.currency!
            webView.coinName = model.currency!
        }
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(webView, animated: true)
        self.hidesBottomBarWhenPushed = false
        
    }
    
    
}