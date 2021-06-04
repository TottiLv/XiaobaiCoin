//
//  XBLoginViewController.swift
//  XiaobaiCoin
//
//  Created by lvjx on 2021/6/4.
//

import Foundation
import UIKit
import SnapKit
import OpenCC

class XBLoginViewController : UIViewController{
    
    var txtUser: UITextField!
    var txtPwd: UITextField!
    var txtBtn: UIButton!
    
    
    var converter: ChineseConverter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.converter = try! ChineseConverter(bundle: bundle!, option: [.traditionalize, .TWStandard, .TWIdiom])
        self.navigationItem.title = self.converter?.convert("登录/注册")
        self.view.backgroundColor = .black
        
        self.setUpUI()
        self.layoutUI()
        self.styleUI()
        self.actionUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    fileprivate func setUpUI(){
        self.txtUser = UITextField.init()
        self.txtUser.delegate = self
        self.view.addSubview(self.txtUser)
        
        self.txtPwd = UITextField.init()
        self.txtPwd.delegate = self
        self.view.addSubview(self.txtPwd)
        
        self.txtBtn = UIButton.init(type: .custom)
        self.view.addSubview(self.txtBtn)
        
    }
    
    fileprivate func layoutUI(){
        self.txtUser?.snp.makeConstraints({ make in
            make.left.right.equalTo(self.view).inset(20)
            make.height.equalTo(44)
            make.top.equalTo(self.view.snp.top).offset(100);
        })
        self.txtPwd?.snp.makeConstraints({ make in
            make.left.right.equalTo(self.view).inset(20)
            make.height.equalTo(44)
            make.top.equalTo(self.txtUser.snp.bottom).offset(20);
        })
        self.txtBtn?.snp.makeConstraints({ make in
            make.left.right.equalTo(self.view).inset(20)
            make.height.equalTo(44)
            make.top.equalTo(self.txtPwd.snp.bottom).offset(44);
        })
    }
    
    fileprivate func styleUI(){
        self.txtUser.layer.cornerRadius = 5
        self.txtUser.layer.borderColor = UIColor.gray.cgColor
        self.txtUser.layer.borderWidth = 0.5
        self.txtUser.tag = 1
        self.txtUser.tintColor = .white
        self.txtUser.attributedPlaceholder = NSAttributedString.init(string:(self.converter?.convert("邮箱"))!, attributes: [
                                                                        NSAttributedString.Key.foregroundColor:UIColor.gray])
        self.txtUser.textColor = .white
        self.txtUser.keyboardType = .emailAddress
        self.txtUser.leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 44))
        self.txtUser.leftViewMode = .always
        
        self.txtPwd.layer.cornerRadius = 5
        self.txtPwd.layer.borderColor = UIColor.gray.cgColor
        self.txtPwd.layer.borderWidth = 0.5
        self.txtPwd.tag = 2
        self.txtPwd.tintColor = .white
        self.txtPwd.attributedPlaceholder = NSAttributedString.init(string:(self.converter?.convert("密码"))!, attributes: [
                                                                        NSAttributedString.Key.foregroundColor:UIColor.gray])
        self.txtPwd.textColor = .white
        self.txtPwd.keyboardType = .emailAddress
        self.txtPwd.isSecureTextEntry = true
        self.txtPwd.leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 44))
        self.txtPwd.leftViewMode = .always
        
        self.txtBtn.setTitle(self.converter?.convert("登录/注册"), for: .normal)
        self.txtBtn.layer.cornerRadius = 5
        self.txtBtn.layer.borderColor = UIColor.gray.cgColor
        self.txtBtn.layer.borderWidth = 0.5
        self.txtBtn.backgroundColor = .red
    }
    
    fileprivate func actionUI(){
        self.txtBtn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
    }
    
    func tipAction(_ title: String?, _ content: String?, _ tag: Int) {
        // 建立一個提示框
        let alertController = UIAlertController(
            title: self.converter?.convert(title ?? "温馨提示"),
            message: self.converter?.convert(content ?? "发生错误，请重新操作"),
            preferredStyle: .alert)


        // 建立[送出]按鈕
        let okAction = UIAlertAction(
            title: self.converter?.convert("确认"),
            style: .default) { _ in
            if 5 == tag {
                self.navigationController?.popViewController(animated: true)
            }
        }
        alertController.addAction(okAction)

        // 顯示提示框
        self.present(
          alertController,
          animated: true,
          completion: nil)
    }
    
    fileprivate func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    @objc func loginAction(){
        let user: String = self.txtUser.text ?? ""
        let pwd: String = self.txtPwd.text ?? ""
        if user.isEmpty {
            self.tipAction("温馨提示", "邮箱不能为空", 1)
            return
        }
        if !self.validateEmail(user) {
            self.tipAction("温馨提示", "请输入正确的邮箱", 2)
            return
        }
        if pwd.isEmpty {
            self.tipAction("温馨提示", "密码不能为空", 3)
            return
        }
        if user == "xiaobaikanbi@163.com" && pwd != "qwe123"{
            self.tipAction("温馨提示", "用户名密码错误，请重新输入", 4)
            return
        }
        UserDefaults.standard.setValue(user, forKey: "XB_USER_NAME")
        UserDefaults.standard.setValue(pwd, forKey: "XB_USER_PWD")
        UserDefaults.standard.synchronize()
        self.tipAction("登录成功", "小白看币，欢迎您!", 5)
    }
    
    lazy var bundle: Bundle? = {
        let openCCBundle = Bundle(for: ChineseConverter.self)
        guard let resourceUrl = openCCBundle.url(forResource: "OpenCCDictionary", withExtension: "bundle") else {
            return nil
        }
        return Bundle(url: resourceUrl)
    }()
}


extension XBLoginViewController : UITextFieldDelegate{
    
}
