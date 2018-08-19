//
//  NavigationController.swift
//  Chat
//
//  Created by laijihua on 2018/8/19.
//  Copyright © 2018 laijihua. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.childViewControllers.count > 0 { // 如果push进来的不是第一个控制器
            let button = UIButton(type: .custom)
            button.setTitle("", for: .normal)
            let backImage = #imageLiteral(resourceName: "nav_back_white")
            button.setImage(backImage, for: .normal)
            button.setImage(backImage, for: .highlighted)
            button.frame = CGRect(x: 0, y: 0, width: 70, height: 30)
            button.contentHorizontalAlignment = .left
            button.addTarget(self, action: #selector(actionForBack(sender:)), for: .touchUpInside)
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }

    @objc func actionForBack(sender: UIButton) {
        popViewController(animated: true)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        // 对特殊的 vc 进行相关的定制化
        if let topVc = self.topViewController {
            return topVc.preferredStatusBarStyle
        }
        return super.preferredStatusBarStyle
    }

}
