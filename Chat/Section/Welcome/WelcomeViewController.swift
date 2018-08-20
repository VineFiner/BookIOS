//
//  WelcomeViewController.swift
//  Chat
//
//  Created by laijihua on 2018/8/19.
//  Copyright © 2018 laijihua. All rights reserved.
//

import UIKit

protocol WelcomeViewControllerDelegate: NSObjectProtocol {
    func welcomeViewControllerForDimissButtonClick(controller: WelcomeViewController)
}

class CustomPageControl: UIView {

    var imageViews: [UIImageView] = []
    var selectIndex: Int = 0 {
        didSet {
            imageViews.forEach({ $0.image = #imageLiteral(resourceName: "guide_wel_nor") })
            imageViews[selectIndex].image = #imageLiteral(resourceName: "guide_wel_sel")
        }
    }

    private var pageTotoalCount: Int

    init(frame: CGRect, pageTotoalCount: Int) {
        self.pageTotoalCount = pageTotoalCount
        super.init(frame: frame)
        setup(pageCount: pageTotoalCount)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(pageCount: Int) {
        for index in 0..<pageCount {
            let imageView = UIImageView(frame: CGRect(x: 20 * index, y: 0, width: 20, height: 7))
            self.addSubview(imageView)
            imageView.contentMode = .scaleAspectFit
            imageViews.append(imageView)
        }
        self.selectIndex = 0
    }

}

class WelcomeViewController: UIViewController {

    weak var delegate: WelcomeViewControllerDelegate?
    var pageControl: CustomPageControl!
    var scrollView: UIScrollView!
    var loginBtnAction:(() -> Void)?

    lazy var logoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 80)
        label.text = "再 书"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        scrollView = UIScrollView(frame: self.view.bounds)
        view.addSubview(scrollView)
        let width = view.ext.width
        let height = view.ext.height
        scrollView.bounces = false

        let imageCount = 4
        for index in 0..<imageCount {
            let rect = CGRect(x: CGFloat(index) * width, y: 0, width: width, height: height)
            let imageView = UIImageView(frame: rect)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            scrollView.addSubview(imageView)
            imageView.image = UIImage(named: "guide_wel_\(index)")
        }

        pageControl = CustomPageControl(frame: CGRect(x: 0, y: 0, width: 60, height: 7), pageTotoalCount: imageCount)
        var bf = pageControl.ext
        bf.bottom = scrollView.ext.height - 150
        bf.centerX = scrollView.ext.centerX

        let loginButton = UIButton(frame: CGRect(x: self.view.ext.width / 4, y: pageControl.ext.bottom + 30, width: view.ext.width - self.view.ext.width / 2, height: 44))
        loginButton.backgroundColor = UIColor(white: 0, alpha: 0.7)
        loginButton.layer.cornerRadius = loginButton.ext.height / 2
        loginButton.setTitle("登入", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.addTarget(self , action: #selector(nextButtonClick(sender:)), for: .touchUpInside)
        view.addSubview(loginButton)

        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: view.ext.width * CGFloat(imageCount), height: view.ext.height)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        view.addSubview(pageControl)
        view.addSubview(logoLabel)
        let logoLabelW: CGFloat = 200.f
        logoLabel.frame = CGRect(x: view.ext.centerX - logoLabelW / 2, y: 120.f, width: logoLabelW, height: 80.f)
    }

    @objc func nextButtonClick(sender: UIButton) {
        self.delegate?.welcomeViewControllerForDimissButtonClick(controller: self)
        self.loginBtnAction?()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

extension WelcomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x  / scrollView.ext.width)
        pageControl.selectIndex = index
    }
}
