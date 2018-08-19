//
//  PageTitleView.swift
//  Chat
//
//  Created by laijihua on 2018/8/19.
//  Copyright © 2018 laijihua. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import NSObject_Rx

extension HomePageViewController {
    final class PageTitleView: UIView {

        private let searchButton: UIButton = UIButton()

        private let scrollView = UIScrollView()

        struct Const {
            static let itemPadding: CGFloat = 20.0
            static let defaultColor: UIColor = .gray
            static let selectColor: UIColor = .black
        }

        typealias ClickIndex = (Int) -> Void

        var searchAction: (() -> Void)?

        private var buttons: [UIButton] = []
        private var lastButton: UIButton?
        private var clickIndex: ClickIndex?

        var index: Int = 0 {
            didSet {
                switchIndex(index: index)
            }
        }


        init(frame: CGRect, titles: [String], click: ClickIndex?) {
            self.clickIndex = click
            super.init(frame: frame)
            setup(titles: titles)
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func setup(titles: [String]) {
            self.addSubview(scrollView)
            self.addSubview(searchButton)
            let searchW: CGFloat = 28
            let searchH: CGFloat = 28
            let rightPW: CGFloat = 50
            let btnPadding: CGFloat = (rightPW - 2 * searchW) / 3
            scrollView.frame = CGRect(x: 0, y: 0, width: self.ext.width - rightPW, height: self.ext.height)


            self.searchButton.frame = CGRect(x: scrollView.ext.right + btnPadding / 2, y: (self.ext.height - searchH) / 2, width: searchW, height: searchH)
            self.searchButton.setImage(#imageLiteral(resourceName: "com_nav_search"), for: .normal)

            self.searchButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self]() in
                self?.searchAction?()
            }).disposed(by: rx.disposeBag)

            scrollView.showsHorizontalScrollIndicator = false
            buttons.removeAll()
            let height: CGFloat = 30
            let y: CGFloat = (scrollView.ext.height - height) / 2
            let titleFont: UIFont = UIFont.systemFont(ofSize: 15)
            var x: CGFloat =  20

            for (index, title) in titles.enumerated() {
                let width = title.ext.width(font: titleFont, height: height)
                let frame = CGRect(x: x, y: y, width: width, height: height)
                x += width + Const.itemPadding
                let button = UIButton(frame: frame)
                button.setTitle(title, for: .normal)
                button.setTitleColor(Const.defaultColor, for: .normal)
                button.titleLabel?.font = titleFont
                buttons.append(button)
                scrollView.addSubview(button)
                button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self]() in
                    self?.switchIndex(index: index)
                }).disposed(by: rx.disposeBag)
            }
            let cWidth = max(scrollView.ext.width, (buttons.last?.ext.right ?? 0) + Const.itemPadding)

            scrollView.contentSize = CGSize(width: cWidth, height: scrollView.ext.height)
            switchIndex(index: index)
        }

        func switchIndex(index: Int) {
            guard buttons.count > index else {return}
            lastButton?.setTitleColor(Const.defaultColor, for: .normal)
            let button = buttons[index]
            button.setTitleColor(Const.selectColor, for: .normal)
            lastButton = button

            var offset = button.ext.centerX - self.ext.width / 2
            if offset < 0 {
                offset = 0
            }
            let maxoffset = scrollView.contentSize.width - scrollView.ext.width
            if offset > maxoffset {
                offset = maxoffset
            }
            scrollView.setContentOffset(CGPoint.init(x: offset, y: 0), animated: true)

            clickIndex?(index)
        }

    }
}
