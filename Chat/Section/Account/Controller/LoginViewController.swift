//
//  ViewController.swift
//  Chat
//
//  Created by laijihua on 2018/5/31.
//  Copyright © 2018 laijihua. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import NSObject_Rx

final class LoginViewController: UIViewController {

    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "输入您的邮箱"
        return textField
    }()

    lazy var passwdTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "输入你的密码"
        return textField
    }()

    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("登录", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        return button
    }()

    lazy var registeButton: UIButton = {
        let button = UIButton()
        button.setTitle("注册", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        return button
    }()

    var viewModel: LoginViewModel

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setup()
    }

    private func setup() {
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwdTextField)
        self.view.addSubview(loginButton)
        self.view.addSubview(registeButton)
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: {[weak self]_ in
            self?.view.endEditing(true)
        }).disposed(by: rx.disposeBag)
        self.view.addGestureRecognizer(tapGesture)
        setupLayout()
        setupEvents()
    }

    private func setupEvents() {
        loginButton
            .rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] in
                self?.login()
            }).disposed(by: rx.disposeBag)

        registeButton
            .rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] in
                self?.registe()
            }).disposed(by: rx.disposeBag)
    }

    private func setupLayout() {
        let body: UIView = self.view
        emailTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(body).inset(20)
            make.top.equalTo(30)
            make.height.equalTo(30)
        }

        passwdTextField.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(emailTextField)
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
        }

        loginButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(body).inset(50)
            make.height.equalTo(30)
            make.top.equalTo(passwdTextField.snp.bottom).offset(20)
        }

        registeButton.snp.makeConstraints { (make) in
            make.left.height.right.equalTo(loginButton)
            make.top.equalTo(loginButton.snp.bottom).offset(20)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - Net
extension LoginViewController {
    /// 注册
    private func registe() {
        let registerViewModel = RegisterViewModel(provider: viewModel.networkProvider, navigator: viewModel.navigator)
        let registeVc = RegistViewController(viewModel: registerViewModel)
        self.navigationController?.pushViewController(registeVc, animated: true)
    }

    /// 登录
    private func login() {
        guard let email = self.emailTextField.text else {return}
        guard let passwd = self.passwdTextField.text else {return}

        self.viewModel
            .networkProvider.request(ChatApi.login(email: email, password: passwd),
                                disposed: rx.disposeBag,
                                success: { [weak self](response: Response<Token>) in
                                    guard let weakSelf = self, response.isOk else {return}
                                    Share.shared.token = response.data
                                    weakSelf.getUserInfo()
                                }) { (error) in

                                }
    }

    private func getUserInfo() {
        self.viewModel.networkProvider.request(ChatApi.userInfo, disposed: rx.disposeBag, success: { [weak self](response: Response<User>) in
            guard let _ = self, response.isOk else {return}
            Share.shared.user = response.data
            AppDelegate.jumpToHomePageComtroller()
        }) { (error) in

        }

    }
}

