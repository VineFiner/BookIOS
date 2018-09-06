//
//  FillInfoViewController.swift
//  Chat
//
//  Created by laijihua on 2018/8/19.
//  Copyright © 2018 laijihua. All rights reserved.
//

import UIKit
import ZLPhotoBrowser
import TextFieldEffects
import PKHUD
import TKSubmitTransition

extension FillInfoViewController: ViewStyleAble {
    struct Color {
        static let titleLabel = UIColor.gray
        static let registeBtnBgColor = UIColor.black
        static let registeBtnTitleColor = UIColor.white
        static let registeSpinerColor = UIColor.white
    }

    struct Font {
        static let titleLabel = UIFont.systemFont(ofSize: 17)
    }

    struct Matric {
        static let avatorHW: CGFloat = 100
        static let textFileldHeight = 50.f
        static let registeBtttonHeight = 44.adapter
    }
    struct Other {
        static let title = "个人消息补全"
        static let info = "个人资料"
        static let next = "提交"
        static let name = "昵称"
    }

}

class FillInfoViewController: UIViewController {

    var user: User
    var token: String

    let avatorButton: UIButton = UIButton()

    private var imageData: Data?

    lazy var nameTextField: HoshiTextField = {
        let textField = HoshiTextField(frame: CGRect(x: self.gMargin * 2,
                                                     y: self.avatorButton.bf.bottom + self.gMargin * 2,
                                                     width: self.view.bf.width - 4 * self.gMargin,
                                                     height: Matric.textFileldHeight))
        textField.placeholderColor = Color.titleLabel
        textField.textAlignment = .center
        textField.placeholder = Other.name
        textField.text = self.user.name
        textField.borderInactiveColor = self.gLineColor
        textField.borderActiveColor = .black
        textField.font = Font.titleLabel
        textField.placeholderFontScale = 1
        return textField
    }()

    lazy var infoTextField: HoshiTextField = {
        let textField = HoshiTextField(frame: CGRect(x: self.gMargin * 2,
                                                     y: self.nameTextField.bf.bottom + self.gMargin * 2,
                                                     width: self.view.bf.width - 4 * self.gMargin,
                                                     height: Matric.textFileldHeight))
        textField.placeholderColor = Color.titleLabel
        textField.textAlignment = .center
        textField.placeholder = Other.info
        textField.borderInactiveColor = self.gLineColor
        textField.borderActiveColor = .black
        textField.font = Font.titleLabel
        textField.placeholderFontScale = 1
        return textField
    }()

    lazy var nextButton: TKTransitionSubmitButton = {
        let width = self.view.bf.width - 8 * self.gMargin
        let btn = TKTransitionSubmitButton(frame: CGRect(x: 4 * self.gMargin, y: self.infoTextField.bf.bottom + 30, width: width, height: Matric.registeBtttonHeight))
        btn.spinnerColor = Color.registeSpinerColor
        btn.backgroundColor = Color.registeBtnBgColor
        btn.setTitle(Other.next, for: .normal)
        btn.setTitleColor(Color.registeBtnTitleColor, for: .normal)
        btn.layer.cornerRadius = Matric.registeBtttonHeight / 2
        btn.addTarget(self, action: #selector(actionForNext(sender:)), for: .touchUpInside)
        return btn
    }()

    init(user: User, token: String) {
        self.user = user
        self.token = token
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Other.title
        self.view.backgroundColor = gViewControllerBgColor
        setup()
    }

    private func setup() {
        self.view.addSubview(avatorButton)

        let avatorX = (self.view.bf.width - Matric.avatorHW) / 2
        avatorButton.frame = CGRect.init(x: avatorX, y: 30, width: Matric.avatorHW, height: Matric.avatorHW)
        avatorButton.layer.cornerRadius = Matric.avatorHW / 2
        avatorButton.layer.masksToBounds = true
        avatorButton.layer.borderColor = gLineColor.cgColor
        avatorButton.layer.borderWidth = 1
        avatorButton.setImage(#imageLiteral(resourceName: "login_fill_camera"), for: .normal)
        avatorButton.rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self]() in
                self?.actionForUpload()
            }).disposed(by: rx.disposeBag)

        self.view.addSubview(nameTextField)
        self.view.addSubview(infoTextField)
        self.view.addSubview(nextButton)
    }

    private func actionForUpload() {
        let actionSheet = ZLPhotoActionSheet()
        actionSheet.configuration.maxPreviewCount = 10
        actionSheet.configuration.maxSelectCount = 1
        actionSheet.sender = self
        actionSheet.selectImageBlock = { [weak self](images, assets, isOriginal) in
            guard let first = images?.first,
                let data = UIImagePNGRepresentation(first)
                else {return}
            self?.avatorButton.setImage(first, for: .normal)
            self?.imageData = data
        }
        actionSheet.showPreview(animated: true)
    }

    @objc func actionForNext(sender: UIButton) {
        nextButton.startLoadingAnimation()
        guard let imageData = self.imageData else {
            self.showText("请上传您的靓照")
            nextButton.returnToOriginalState()
            return
        }
        ThirdApi.qnUpload(token: token, data: imageData) { [weak self](key, info) in
            guard let strongSelf = self else {return}
            strongSelf.updateInfo(url: Config.shared.qnImageHost + key)
        }
    }

    func updateInfo(url: String) {
        let request = UpdateUserRequest(userId: user.identifier, token: token, name: self.nameTextField.text, avator: url, info: self.infoTextField.text, password: nil)
        Api.send(request, handler: { [weak self](response) in
            guard let strongSelf = self, let res = response else { return }
            if res.isOk {
                // 跳转到首页
                strongSelf.nextButton.startFinishAnimation(1, completion: {
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.switchToAppIndexUI()
                    }
                })
            } else {
                strongSelf.nextButton.returnToOriginalState()
                strongSelf.showText(res.message)
            }
        })
    }

}
