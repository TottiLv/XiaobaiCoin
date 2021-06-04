//
//  XBNewsTableViewCell.swift
//  XiaobaiCoin
//
//  Created by lvjx on 2021/5/18.
//

import UIKit
import SnapKit
import OpenCC
//https://www.jianshu.com/p/5adc18761666
class XBNewsTableViewCell: UITableViewCell {
    var timeLabel: UILabel?//999999
    var titleLabel: UILabel?//ffffff
    var contentLabel: UILabel?//828491
    var converter: ChineseConverter?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.converter = try! ChineseConverter(bundle: bundle!, option: [.traditionalize, .TWStandard, .TWIdiom])
        self.backgroundColor = UIColor.init(rgb: 0x1D1E27)
        self.setUpUI()
        self.layoutUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func setValueForCell(_ model: XBNewsContent){
        let date = Date.init(timeIntervalSince1970: model.created_at ?? 0)
        
        let str = model.content
        if str?.count ?? 0 > 0 {
            let result: [String] = str!.components(separatedBy: "】")
            var title: String = self.converter?.convert(result[0]) ?? ""
            title.append("】")
            self.titleLabel?.text =  title
            self.contentLabel?.text = self.converter?.convert(result[1]) ?? ""
        }
        
        self.timeLabel?.text = XBTools.shared.date2String(date)
        
    }
    
    fileprivate func setUpUI(){
        self.timeLabel = UILabel.init()
        self.timeLabel?.font = .systemFont(ofSize: 15)
        self.timeLabel?.textColor = UIColor.init(rgb: 0x999999)
        self.addSubview(self.timeLabel!)
        
        self.titleLabel = UILabel.init()
        self.titleLabel?.font = .boldSystemFont(ofSize: 17)
        self.titleLabel?.textColor = UIColor.init(rgb: 0xffffff)
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.lineBreakMode = .byCharWrapping
        self.addSubview(self.titleLabel!)
        
        self.contentLabel = UILabel.init()
        self.contentLabel?.font = .systemFont(ofSize: 15)
        self.contentLabel?.textColor = UIColor.init(rgb: 0x828491)
        self.contentLabel?.numberOfLines = 0
        self.contentLabel?.lineBreakMode = .byCharWrapping
        self.addSubview(self.contentLabel!)
    }
    
    fileprivate func layoutUI(){
        self.timeLabel?.snp.makeConstraints({ make in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).inset(10)
            make.top.equalTo(self).inset(5)
            make.height.greaterThanOrEqualTo(0)
        })
        
        self.titleLabel?.snp.makeConstraints({ make in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).inset(10)
            make.top.equalTo(self.timeLabel!.snp.bottom)
            make.height.greaterThanOrEqualTo(0)
        })
        
        self.contentLabel?.snp.makeConstraints({ make in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).inset(10)
            make.top.equalTo(self.titleLabel!.snp.bottom)
            make.height.greaterThanOrEqualTo(0)
            make.bottom.equalTo(self.snp.bottom).offset(-5)
        })
    }
    
    lazy var bundle: Bundle? = {
        let openCCBundle = Bundle(for: ChineseConverter.self)
        guard let resourceUrl = openCCBundle.url(forResource: "OpenCCDictionary", withExtension: "bundle") else {
            return nil
        }
        return Bundle(url: resourceUrl)
    }()
}

