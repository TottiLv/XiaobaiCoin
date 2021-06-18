//
//  TLMediaNewsViewController.swift
//  XiaobaiCoin
//
//  Created by lvjx on 2021/5/18.
//

import UIKit
import SnapKit
import HandyJSON
import ESPullToRefresh
import OpenCC

class TLMediaNewsViewController : UIViewController{
    
    var tableView: UITableView?
    var bottomId: Int?
    var newsLists: NSMutableArray?
    var converter: ChineseConverter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.converter = try! ChineseConverter(bundle: bundle!, option: [.traditionalize, .TWStandard, .TWIdiom])
        self.navigationItem.title = self.converter?.convert("快讯")
        self.view.backgroundColor = .black
        self.bottomId = -1
        self.newsLists = NSMutableArray.init();
        
        
        self.__setupUI()
        self.__layoutUI()
        self.__fetchNewsList()
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

extension TLMediaNewsViewController{
    
    fileprivate func __setupUI(){
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        self.tableView?.separatorStyle = .none//去掉分割线
        self.tableView?.backgroundColor = .black
        self.tableView?.allowsSelection = false //禁止点击
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.estimatedRowHeight = 120
        self.tableView?.rowHeight = UITableView.automaticDimension
        self.view.addSubview(self.tableView!)
        //注册CELL
        self.tableView?.register(TLMediaNewsTableViewCell.self, forCellReuseIdentifier: "newsCell")
        //清除多余cell分割线
        self.tableView?.tableFooterView = UIView()
        
        //下拉刷新
        self.tableView?.es.addPullToRefresh {
            [weak self] in
            self?.bottomId = -1
            self?.newsLists?.removeAllObjects()
            self?.__fetchNewsList()
            self?.tableView?.es.stopPullToRefresh()
        }
        
        self.tableView?.es.addInfiniteScrolling {
            [weak self] in
            self?.__fetchNewsList()
            self?.tableView?.es.stopLoadingMore()
        }
    }
    
    fileprivate func __layoutUI(){
        self.tableView?.snp.makeConstraints({ make in
            make.top.equalTo(self.view.snp.top).offset(TLMediaTools.shared.safeArea().top+44)
            make.bottom.equalTo(self.view.snp.bottom).inset(TLMediaTools.shared.safeArea().bottom+44)
            make.left.right.equalTo(self.view)
        })
    }
    
    fileprivate func __fetchNewsList(){
        var param = [String: Any]()
        param["flag"] = "down"
        if self.bottomId! > 0 {
            param["id"] = (self.bottomId!)
        }
        self.__showLoadingView()
        API.News.newsList.fetch(param, headers: nil) { response in
            self.__removeLoadingView()
            let json = response as! NSDictionary
            if let result = JSONDeserializer<TLMediaNewsModel>.deserializeFrom(dict: json){
                self.bottomId = result.bottom_id
                let ls: [TLMediaNewsList] = result.list ?? []
                if ls.count > 0 {
                    let news: TLMediaNewsList = ls[0]
                    self.newsLists?.addObjects(from: news.lives!)
                }
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

extension TLMediaNewsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.newsLists?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    //行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identify: String = "newsCell"
        let cell = TLMediaNewsTableViewCell(style: .default, reuseIdentifier: identify)
        
        if self.newsLists?.count ?? 0 > indexPath.section {
            let model: TLMediaNewsContent = self.newsLists?.object(at: indexPath.section) as! TLMediaNewsContent
            cell.setValueForCell(model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
    
    //返回cell的高度，默认高度是44
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 120
//    }
    
    //cell的点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
