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
import TKSubmitTransition
import FDFullscreenPopGesture
import IQKeyboardManagerSwift

extension LoginViewController: ViewStyleAble {
    struct Color {
        static let bgColor = UIColor.black
        static let loginButtonColor = UIColor.white
        static let loginButtonTitleColor = UIColor.black
        static let textFieldTextColor = UIColor.white
        static let forgetPwdBtnColor = UIColor(hexString: "#787878")
        static let registeBtnColor = UIColor.white
        static let loginBtnSpinnerColor = UIColor.black
    }

    struct Font {

    }

    struct Matric {
        static let imageTextFieldViewTopMargin = 2.adapter
        static let imageTextFieldViewTopHeight = 48.adapter
        static let pwdTextFieldViewTopMarigin = 20.adapter
        static let loginButtonTopMargin = 30.adapter
        static let loginButtonHeight = 44.adapter
        static let loginButtonBottomMargin = 10.adapter
        static let forgetPwdButtonHeight = 34.adapter
        static let forgeetPwdButtonWidth = 100.adapter
        static let floatMargin: CGFloat = 30.adapter
    }

    struct Other {
        static let loginText = "登录"
        static let emailPlaceholder = "请输入邮箱"
        static let pwdPlaceholder = "请输入密码"
        static let forgetPwd = "忘记密码"
        static let registe = "注册账号"
    }
}

final class LoginViewController: UIViewController {

    var viewModel: LoginViewModel

    lazy var loginButton: TKTransitionSubmitButton = {
        let width = self.view.ext.width - 4 * self.gMargin
        let btn = TKTransitionSubmitButton(frame: CGRect(origin: .zero, size: CGSize(width: width, height: Matric.loginButtonHeight)))
        btn.spinnerColor = Color.loginBtnSpinnerColor
        btn.backgroundColor = Color.loginButtonColor
        btn.setTitle(Other.loginText, for: .normal)
        btn.setTitleColor(Color.loginButtonTitleColor, for: .normal)
        btn.layer.cornerRadius = Matric.loginButtonHeight / 2
        btn.addTarget(self, action: #selector(actionForLogin(sender:)), for: .touchUpInside)
        return btn
    }()

    lazy var bgView: UIImageView = {
        let bgFrame = CGRect.init(x: -2 * Matric.floatMargin, y: -Matric.floatMargin * 2, width: self.view.ext.width + Matric.floatMargin * 4, height: self.view.ext.height + Matric.floatMargin * 4)
        let imagev = UIImageView(frame: bgFrame)
        imagev.contentMode = .scaleAspectFill
        imagev.clipsToBounds = true
        imagev.image = #imageLiteral(resourceName: "login_view_bg")
        return imagev
    }()

    lazy var imageView: UIImageView = {
        let imagev = UIImageView()
        imagev.image = #imageLiteral(resourceName: "account_logo")
        imagev.contentMode = .scaleAspectFit
        imagev.clipsToBounds = true
        return imagev
    }()

    lazy var emailImageTextFieldView: ImageTextFieldView = {
        let email = ImageTextFieldView()
        email.icon = #imageLiteral(resourceName: "account_emai")
        email.placeholder = Other.emailPlaceholder
        email.textField.keyboardType = .emailAddress
        email.textField.autocorrectionType = UITextAutocorrectionType.no
        return email
    }()

    lazy var forgetPwdButton: UIButton = {
        let button = UIButton()
        button.setTitle(Other.forgetPwd, for: .normal)
        button.setTitleColor(Color.forgetPwdBtnColor, for: .normal)
        button.addTarget(self, action: #selector(actionForForgetPassword(sender:)), for: .touchUpInside)
        button.titleLabel?.font = self.gButtonTitleFont
        return button
    }()

    lazy var registeButton: UIButton = {
        let button = UIButton()
        button.setTitle(Other.registe, for: .normal)
        button.setTitleColor(Color.registeBtnColor, for: .normal)
        button.addTarget(self, action: #selector(actionForRegiste(sender:)), for: .touchUpInside)
        button.titleLabel?.font = self.gButtonTitleFont
        return button
    }()

    lazy var pwdImageTextFieldView:ImageTextFieldView = {
        let pwd = ImageTextFieldView()
        pwd.icon =  #imageLiteral(resourceName: "account_pwd")
        pwd.textField.isSecureTextEntry = true
        pwd.placeholder = Other.pwdPlaceholder
        return pwd
    }()

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fd_prefersNavigationBarHidden = true
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 80
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 10
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutSubviews()
    }

    func setup() {
        view.addSubview(bgView)
        view.addSubview(imageView)
        view.addSubview(emailImageTextFieldView)
        view.addSubview(pwdImageTextFieldView)
        view.addSubview(loginButton)
        view.addSubview(forgetPwdButton)
        view.addSubview(registeButton)
        setupBgViewAnimate()
    }

    private func setupBgViewAnimate() {
        let min: CGFloat = -Matric.floatMargin
        let max: CGFloat = Matric.floatMargin
        let xMotion = UIInterpolatingMotionEffect.init(keyPath: "center.x", type: .tiltAlongHorizontalAxis)

        xMotion.minimumRelativeValue = min
        xMotion.maximumRelativeValue = max

        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = min
        yMotion.maximumRelativeValue = max

        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [xMotion,yMotion]
        bgView.addMotionEffect(motionEffectGroup)
    }

    func layoutSubviews() {
        let superView: UIView = self.view
        imageView.snp.makeConstraints { (make) in
            make.left.right.equalTo(superView).inset(100)
            make.top.equalTo(80)
            make.height.equalTo(superView.ext.width - 100)
        }

        emailImageTextFieldView.snp.makeConstraints { (make) in
            make.left.equalTo(gMargin)
            make.right.equalTo(superView).offset(-gMargin)
            make.top.equalTo(imageView.snp.bottom).offset(Matric.imageTextFieldViewTopMargin)
            make.height.equalTo(Matric.imageTextFieldViewTopHeight)
        }

        pwdImageTextFieldView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(emailImageTextFieldView)
            make.top.equalTo(emailImageTextFieldView.snp.bottom).offset(Matric.pwdTextFieldViewTopMarigin)
        }

        loginButton.snp.makeConstraints { (make) in
            make.left.equalTo(pwdImageTextFieldView).offset(gMargin)
            make.right.equalTo(pwdImageTextFieldView).offset(-gMargin)
            make.top.equalTo(pwdImageTextFieldView.snp.bottom).offset(Matric.loginButtonTopMargin)
            make.height.equalTo(Matric.loginButtonHeight)
        }

        forgetPwdButton.snp.makeConstraints { (make) in
            make.left.equalTo(loginButton)
            make.top.equalTo(loginButton.snp.bottom).offset(Matric.loginButtonBottomMargin)
            make.height.equalTo(Matric.forgetPwdButtonHeight)
            make.width.equalTo(Matric.forgeetPwdButtonWidth)
        }

        registeButton.snp.makeConstraints { (make) in
            make.right.equalTo(loginButton)
            make.top.width.height.equalTo(forgetPwdButton)
        }
    }

    @objc func actionForForgetPassword(sender: UIButton) {
        let forgetPwdVc = FogetPwdViewController()
        self.navigationController?.pushViewController(forgetPwdVc, animated: true)
    }

    @objc func actionForRegiste(sender: UIButton) {
        let registeViewModel = RegisterViewModel(provider: viewModel.networkProvider, navigator: viewModel.navigator)
        let registeVc = RegisterViewController(viewModel: registeViewModel)
        self.navigationController?.pushViewController(registeVc, animated: true)
    }

    @objc func actionForLogin(sender: UIButton) {
        //
        guard let email = self.emailImageTextFieldView.textField.text, email.count > 0 else {
            self.ext.showText(Other.emailPlaceholder)
            return
        }

        guard let pwd = self.pwdImageTextFieldView.textField.text, pwd.count > 0 else {
            self.ext.showText(Other.pwdPlaceholder)
            return
        }

        guard email.ext.isEmail else {
            self.ext.showText("无效的邮箱账号")
            return
        }
        loginButton.startLoadingAnimation()
        self.viewModel
            .networkProvider.request(ChatApi.login(email: email, password: pwd.ext.pwdStr),
                                     disposed: rx.disposeBag,
                                     success: { [weak self](response: Response<Token>) in
                                        guard let weakSelf = self else {return}
                                        if response.isOk {
                                            Share.shared.token = response.data
                                            weakSelf.getUserInfo()
                                        } else {
                                            weakSelf.loginButton.returnToOriginalState()
                                            weakSelf.ext.showText(response.message)
                                        }
            }) { (error) in

        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - Net
extension LoginViewController {
    /// 注册
    private func registe() {
        let registerViewModel = RegisterViewModel(provider: viewModel.networkProvider, navigator: viewModel.navigator)
        let registeVc = RegisterViewController(viewModel: registerViewModel)
        self.navigationController?.pushViewController(registeVc, animated: true)
    }

    private func getUserInfo() {
        self.viewModel.networkProvider.request(ChatApi.userInfo, disposed: rx.disposeBag, success: { [weak self](response: Response<User>) in
            guard let strongSelf = self else {return}
            if (response.isOk) {
                strongSelf.loginButton.startFinishAnimation(1, completion: {
                    Share.shared.user = response.data
                    AppDelegate.jumpToHomePageComtroller()
                })
            } else {
                strongSelf.loginButton.returnToOriginalState()
                strongSelf.ext.showText(response.message)
            }
        }) { (error) in

        }

    }
}

