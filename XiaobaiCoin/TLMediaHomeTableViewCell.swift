//
//  TLMediaHomeTableViewCell.swift
//  XiaobaiCoin
//
//  Created by lvjx on 2021/5/18.
//

import UIKit
import SnapKit
import SDWebImage
import OpenCC

//https://www.jianshu.com/p/5adc18761666
class TLMediaHomeTableViewCell: UITableViewCell {
    var coinImageView: UIImageView?
    var coinNameLabel: UILabel?//ffffff
    var coinValueLabel: UILabel? //999999
    var coinPriceLabel: UILabel?//999999
    var coinPriceLimitLabel: UILabel?// red/green
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
    
    lazy var bundle: Bundle? = {
        let openCCBundle = Bundle(for: ChineseConverter.self)
        guard let resourceUrl = openCCBundle.url(forResource: "OpenCCDictionary", withExtension: "bundle") else {
            return nil
        }
        return Bundle(url: resourceUrl)
    }()
}

extension TLMediaHomeTableViewCell{
    func setValueForCell(_ model: TLMediaHomeMode){
        self.coinImageView?.sd_setImage(with: URL(string: model.iconUrl!), placeholderImage: UIImage(named: "ic_B"))
        self.coinNameLabel?.text = self.converter?.convert(model.name ?? "")
        let cap: Double = model.marketCap ?? 0
        self.coinValueLabel?.text = String(format: "%.2f",cap/100000000)+(self.converter?.convert("亿"))!
        self.coinPriceLabel?.text = String(model.price ?? 0)
        let change: Double = model.change ?? 0
        self.coinPriceLimitLabel?.text = String(change)
        if change > 0.0 {
            self.coinPriceLimitLabel?.textColor = .green
        }else{
            self.coinPriceLimitLabel?.textColor = .red
        }
    }
}

extension TLMediaHomeTableViewCell{
    fileprivate func setUpUI(){
        self.coinImageView = UIImageView()
        self.addSubview(self.coinImageView!)
        
        self.coinNameLabel = UILabel.init()
        self.coinNameLabel?.font = .boldSystemFont(ofSize: 17)
        self.coinNameLabel?.textColor = UIColor.init(rgb: 0xffffff)
        self.addSubview(self.coinNameLabel!)
        
        self.coinValueLabel = UILabel.init()
        self.coinValueLabel?.font = .systemFont(ofSize: 11)
        self.coinValueLabel?.textColor = UIColor.init(rgb: 0x828491)
        self.addSubview(self.coinValueLabel!)
        
        self.coinPriceLabel = UILabel.init()
        self.coinPriceLabel?.font = .boldSystemFont(ofSize: 17)
        self.coinPriceLabel?.textColor = UIColor.init(rgb: 0xffffff)
        self.coinPriceLabel?.textAlignment = .center
        self.addSubview(self.coinPriceLabel!)
        
        self.coinPriceLimitLabel = UILabel.init()
        self.coinPriceLimitLabel?.font = .boldSystemFont(ofSize: 17)
        self.coinPriceLimitLabel?.textColor = UIColor.red
        self.coinPriceLimitLabel?.textAlignment = .right
        self.addSubview(self.coinPriceLimitLabel!)
    }
    
    fileprivate func layoutUI(){
        self.coinImageView?.snp.makeConstraints({ make in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(self).inset(10)
            make.width.height.equalTo(30)
        })
        
        self.coinNameLabel?.snp.makeConstraints({ make in
            make.left.equalTo(self.coinImageView!.snp.right).offset(2)
            make.centerY.equalTo(self.coinImageView!.snp.centerY)
            make.height.equalTo(24)
            make.right.equalTo(self.coinPriceLabel!.snp.left).offset(-5)
        })
        
        self.coinValueLabel?.snp.makeConstraints({ make in
            make.left.equalTo(self.coinImageView!.snp.left)
            make.right.equalTo(self.coinNameLabel!.snp.right)
            make.top.equalTo(self.coinImageView!.snp.bottom)
            make.height.equalTo(18)
        })
        self.coinPriceLabel?.snp.makeConstraints({ make in
            make.width.equalTo(120)
            make.centerY.equalTo(self.snp.centerY)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(30)
        })
        
        self.coinPriceLimitLabel?.snp.makeConstraints({ make in
            make.right.equalTo(self).inset(10)
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.centerY.equalTo(self.snp.centerY)
        })
    }
}
