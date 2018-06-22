//
//  RegistViewController.swift
//  Chat
//
//  Created by laijihua on 2018/6/16.
//  Copyright © 2018 laijihua. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

final class RegistViewController: UIViewController {

    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "输入您的昵称"
        return textField
    }()

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

    lazy var registeButton: UIButton = {
        let button = UIButton()
        button.setTitle("注册", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        return button
    }()

    var networkProvider: NetworkManager

    init(networkProvider: NetworkManager) {
        self.networkProvider = networkProvider
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
        self.view.addSubview(nameTextField)
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwdTextField)
        self.view.addSubview(registeButton)
        setupLayout()
        setupEvents()
    }

    private func setupEvents() {
        registeButton
            .rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] in
                self?.registe()
            }).disposed(by: rx.disposeBag)

        let tapGesture = UITapGestureRecognizer()
        tapGesture
            .rx
            .event
            .subscribe(onNext: {[weak self]_ in
                self?.view.endEditing(true)
            }).disposed(by: rx.disposeBag)
        self.view.addGestureRecognizer(tapGesture)
    }

    private func setupLayout() {
        let body: UIView = self.view

        nameTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(body).inset(20)
            make.top.equalTo(30)
            make.height.equalTo(30)
        }

        emailTextField.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameTextField)
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
        }

        passwdTextField.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(emailTextField)
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
        }

        registeButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(body).inset(50)
            make.height.equalTo(30)
            make.top.equalTo(passwdTextField.snp.bottom).offset(20)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - Net
extension RegistViewController {
    /// 注册
    private func registe() {
        guard let name = nameTextField.text else { return }
        guard let passwd = passwdTextField.text else { return }
        guard let email = emailTextField.text else { return }
        networkProvider.regist(email: email,
                               password: passwd,
                               name: name,
                               disposed: rx.disposeBag,
                               success: { (result) in
                                guard let result = result else {return}
                                Share.shared.token = result.data

        }) { (error) in

        }
    }
}
