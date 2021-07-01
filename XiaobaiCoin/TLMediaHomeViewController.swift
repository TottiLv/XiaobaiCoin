//
//  TLMediaHomeViewController.swift
//  XiaobaiCoin
//
//  Created by lvjx on 2021/5/18.
//

import UIKit
import SnapKit
import HandyJSON
import ESPullToRefresh
import OpenCC

class TLMediaHomeViewController : UIViewController{
    
    var tableView: UITableView?
    var coinsList: NSMutableArray?
    var converter: ChineseConverter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.converter = try! ChineseConverter(bundle: bundle!, option: [.traditionalize, .TWStandard, .TWIdiom])
        self.navigationItem.title = self.converter?.convert("行情")
        self.view.backgroundColor = .white
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
    
    
    
    lazy var loadingView: TLMediaLoadingView = {
        let loadingView: TLMediaLoadingView = TLMediaLoadingView(frame: CGRect(x: self.view.frame.size.width/2-50, y: self.view.frame.size.height/2-50, width: 100, height: 100))
        loadingView.backgroundColor = UIColor(displayP3Red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 0.3)
        return loadingView
    }()
    
    lazy var bundle: Bundle? = {
        let openCCBundle = Bundle(for: ChineseConverter.self)
        guard let resourceUrl = openCCBundle.url(forResource: "OpenCCDictionary", withExtension: "bundle") else {
            return nil
        }
        return Bundle(url: resourceUrl)
    }()
}

extension TLMediaHomeViewController {
    fileprivate func __setupUI(){
        self.tableView = UITableView(frame: CGRect.zero, style: .plain)
        self.tableView?.separatorStyle = .none//去掉分割线
        self.tableView?.backgroundColor = .white
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.view.addSubview(self.tableView!)
        
        //注册CELL
        self.tableView?.register(TLMediaHomeTableViewCell.self, forCellReuseIdentifier: "homeCell")
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
            make.top.equalTo(self.view.snp.top).offset(TLMediaTools.shared.safeArea().top+44)
            make.bottom.equalTo(self.view.snp.bottom).inset(TLMediaTools.shared.safeArea().bottom+44)
            make.left.right.equalTo(self.view)
        })
    }
    
    fileprivate func __fetchCoinValueList(){
        self.__showLoadingView()
        API.Home.pricesList.fetch { response in
            self.__removeLoadingView()
            let json = response as! NSArray
            if let result = JSONDeserializer<TLMediaHomeMode>.deserializeModelArrayFrom(array: json) {
                self.coinsList?.addObjects(from: result as [Any])
                self.tableView?.reloadData()
            }
        } failed: { error in
            self.__removeLoadingView()
        }

    }
    
    
    fileprivate func __showLoadingView(){
        self.view.addSubview(self.loadingView)
    }
    
    fileprivate func __removeLoadingView(){
        self.loadingView .removeFromSuperview()
    }
}

extension TLMediaHomeViewController: UITableViewDelegate, UITableViewDataSource{
    
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
        let cell = TLMediaHomeTableViewCell(style: .default, reuseIdentifier: identify)
        cell.selectionStyle = .none
        if self.coinsList?.count ?? 0 > indexPath.row {
            let model: TLMediaHomeMode = self.coinsList?.object(at: indexPath.row) as! TLMediaHomeMode
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
        let webView = TLMediaWebView()
        if self.coinsList?.count ?? 0 > indexPath.row {
            let model: TLMediaHomeMode = self.coinsList?.object(at: indexPath.row) as! TLMediaHomeMode
            webView.coinURL = "http://winnie33.cc/#/detail?currency="+model.currency!
            webView.coinName = model.currency!
        }
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(webView, animated: true)
        self.hidesBottomBarWhenPushed = false
        
    }
    
    
}
