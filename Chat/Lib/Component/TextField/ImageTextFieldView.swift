//
//  ImageTextFieldView.swift
//  Lovili
//
//  Created by laijihua on 01/09/2017.
//  Copyright © 2017 oheroj. All rights reserved.
//

import UIKit
import SnapKit
import TextFieldEffects

extension ImageTextFieldView: ViewStyleAble {

    struct Color {
        static let line = UIColor.white
        static let text = UIColor.white
    }

    struct Font {
    }

    struct Matric {
        static let iconSize = CGSize(width: 25, height: 25)
        static let iconBottomMargin = 4.f
        static let textfileLeftMargin = 2.f
    }
    struct Other {
    }
}


class ImageTextFieldView: UIView {

    var placeholder: String! {
        didSet {
            self.textField.placeholder = placeholder
        }
    }
    var icon: UIImage! {
        didSet {
            self.imageView.setImage(icon, for: .normal)
            self.imageView.setImage(icon, for: .disabled)
        }
    }

    lazy var imageView: UIButton = {
        let iage = UIButton()
        iage.isEnabled = false
        return iage
    }()

    lazy var textField: JiroTextField = {
        let textf = JiroTextField()
        textf.placeholderColor = .white
        textf.textColor = Color.text
        return textf
    }()

    lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = Color.line
        return line
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    func setup() {
        self.addSubview(imageView)
        self.addSubview(textField)
        self.addSubview(lineView)
    }

    func setupLayout() {
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self)
            make.height.equalTo(gLineViewHeight)
        }
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.size.equalTo(Matric.iconSize)
            make.bottom.equalTo(lineView.snp.top).offset(-Matric.iconBottomMargin)
        }

        textField.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(Matric.textfileLeftMargin)
            make.right.equalTo(self)
            make.bottom.equalTo(imageView)
            make.top.equalTo(self)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
