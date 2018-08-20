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
import TKSubmitTransition
import ActiveLabel

extension RegisterViewController: ViewStyleAble {
    struct Color {
        static let registeBtnBgColor = UIColor.black
        static let registeBtnTitleColor = UIColor.white
        static let textFieldTextColor = UIColor.black
        static let textFieldPlaceTextColor = UIColor.darkGray
        static let protocolLabel = UIColor.gray
        static let protocolSpecialText = UIColor.black
        static let registeSpinerColor = UIColor.white
    }

    struct Font {
        static let protoclLabel = UIFont.systemFont(ofSize: 14)
    }

    struct Matric {
        static let registeBtttonHeight = 44.adapter
        static let emailImageTextViewTopMargin = 20.adapter
        static let emailImageTextViewHeight = 50.adapter
        static let userImageTextViewTopMargin = 20.adapter
        static let pwdImageTextViewTopMargin = 20.adapter
        static let protocolLabelTopMargin = 20.adapter

    }
    struct Other {
        static let title = "注册"
        static let name = "请输入用户名字"
        static let email = "请输入邮箱"
        static let invalidEmail = "无效的邮箱账号"
        static let registe = "立即注册"
        static let password = "请输入密码"
        static let username = "请输入用户名"
        static let protocolTitle = "点击注册，表示同意《再书用户协议》"
        static let protocolSpecilText = "《再书用户协议》"
    }
}

final class RegisterViewController: UIViewController {

    lazy var emailImageTextFieldView: ImageTextFieldView = {
        let view = ImageTextFieldView()
        view.placeholder = Other.email
        view.lineView.backgroundColor = Color.registeBtnBgColor
        view.textField.placeholderColor = Color.textFieldPlaceTextColor
        view.icon = #imageLiteral(resourceName: "account_email_black")
        view.textField.keyboardType = .emailAddress
        view.textField.textColor = Color.textFieldTextColor
        return view
    }()

    lazy var pwdImageTextFieldView: ImageTextFieldView = {
        let view = ImageTextFieldView()
        view.placeholder = Other.password
        view.textField.textColor = Color.textFieldTextColor
        view.textField.placeholderColor = Color.textFieldPlaceTextColor
        view.icon = #imageLiteral(resourceName: "account_pwd_black")
        view.lineView.backgroundColor = Color.registeBtnBgColor
        view.textField.keyboardType = .emailAddress
        return view
    }()

    lazy var userImageTextFieldView: ImageTextFieldView = {
        let view = ImageTextFieldView()
        view.placeholder = Other.username
        view.textField.textColor = Color.textFieldTextColor
        view.textField.placeholderColor = Color.textFieldPlaceTextColor
        view.icon = #imageLiteral(resourceName: "account_user_black")
        view.lineView.backgroundColor = Color.registeBtnBgColor
        view.textField.keyboardType = .namePhonePad
        return view
    }()

    lazy var registeButton: TKTransitionSubmitButton = {
        let width = self.view.ext.width - 4 * self.gMargin
        let btn = TKTransitionSubmitButton(frame: CGRect(x: 0, y: 0, width: width, height: Matric.registeBtttonHeight))
        btn.spinnerColor = Color.registeSpinerColor
        btn.backgroundColor = Color.registeBtnBgColor
        btn.setTitle(Other.registe, for: .normal)
        btn.setTitleColor(Color.registeBtnTitleColor, for: .normal)
        btn.layer.cornerRadius = Matric.registeBtttonHeight / 2
        btn.addTarget(self, action: #selector(actionForRegiste(sender:)), for: .touchUpInside)
        return btn
    }()

    lazy var protocolLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.numberOfLines = 0

        let customType = ActiveType.custom(pattern: Other.protocolSpecilText)

        label.enabledTypes = [customType]
        label.customColor[customType] = Color.protocolSpecialText
        label.handleCustomTap(for: customType, handler: { (element) in
            let protoclVc = ProtocolViewController()
            self.navigationController?.pushViewController(protoclVc, animated: true)
        })

        label.text = Other.protocolTitle
        label.textColor = Color.protocolLabel
        label.font = Font.protoclLabel
        return label
    }()

    var viewModel: RegisterViewModel

    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Other.title
        view.backgroundColor = gVcBgColor
        setup()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutSubViews()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    func setup() {
        view.addSubview(self.emailImageTextFieldView)
        view.addSubview(self.pwdImageTextFieldView)
        view.addSubview(self.registeButton)
        view.addSubview(self.protocolLabel)
        view.addSubview(self.userImageTextFieldView)
    }

    func layoutSubViews() {

        self.userImageTextFieldView.snp.makeConstraints { (make) in
            make.left.equalTo(gMargin)
            make.right.equalTo(self.view).offset(-gMargin)
            make.top.equalTo(Matric.userImageTextViewTopMargin)
            make.height.equalTo(Matric.emailImageTextViewHeight)
        }

        self.emailImageTextFieldView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(self.userImageTextFieldView)
            make.top.equalTo(self.userImageTextFieldView.snp.bottom).offset(Matric.emailImageTextViewTopMargin)
        }

        self.pwdImageTextFieldView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(self.emailImageTextFieldView)
            make.top.equalTo(self.emailImageTextFieldView.snp.bottom).offset(Matric.pwdImageTextViewTopMargin)
        }

        self.registeButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.pwdImageTextFieldView).offset(gMargin)
            make.right.equalTo(self.pwdImageTextFieldView).offset(-gMargin)
            make.height.equalTo(Matric.registeBtttonHeight)
            make.top.equalTo(self.pwdImageTextFieldView.snp.bottom).offset(Matric.pwdImageTextViewTopMargin)
        }

        protocolLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(registeButton)
            make.top.equalTo(self.registeButton.snp.bottom).offset(Matric.protocolLabelTopMargin)
        }

    }

    @objc func actionForRegiste(sender: UIButton) {
        guard let name = self.userImageTextFieldView.textField.text, name.count > 0 else {
            self.ext.showText(Other.username)
            return
        }

        guard let email = self.emailImageTextFieldView.textField.text,
            email.count > 0 else {
                self.ext.showText(Other.email)
                return
        }

        guard email.ext.isEmail else {
            self.ext.showText(Other.invalidEmail)
            return
        }

        guard let password = self.pwdImageTextFieldView.textField.text,
            password.count > 0 else {
                self.ext.showText(Other.password)
                return
        }

        registeButton.startLoadingAnimation()

        viewModel.networkProvider.request(ChatApi.registe(name: name, email: email, password: password.ext.pwdStr),
                                          disposed: rx.disposeBag,
                                          success: { [weak self](response: Response<Token>) in
                                            guard let strongSelf = self else {return}
                                            if (response.isOk) {
                                                Share.shared.token = response.data
                                                strongSelf.getUserInfo()
                                            } else {
                                                strongSelf.registeButton.returnToOriginalState()
                                                strongSelf.ext.showText(response.message)
                                            }
        }) { (error) in

        }
    }

    private func getUserInfo() {
        self.viewModel.networkProvider.request(ChatApi.userInfo, disposed: rx.disposeBag, success: { [weak self](response: Response<User>) in
            guard let strongSelf = self else {return}
            if response.isOk {
                strongSelf.registeButton.startFinishAnimation(1, completion: {
                    Share.shared.user = response.data
                    strongSelf.finishRegist(user: response.data)
                })
            } else {
                strongSelf.registeButton.returnToOriginalState()
                strongSelf.ext.showText(response.message)
            }
        }) { (error) in

        }
    }

    /// 完成注册，跳转到补充资料
    private func finishRegist(user: User?) {
//        let request = LoginRequest(email: user.email, password: password)
//        Api.send(request, handler: { [weak self](response) in
//            guard let strongSelf = self, let res = response else { return }
//            if res.isOk {
//                let vc = FillInfoViewController(user:res.user, token: res.token)
//                strongSelf.navigationController?.pushViewController(vc, animated: true)
//            } else {
//                strongSelf.showText(res.message)
//            }
//        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

