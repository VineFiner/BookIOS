//
//  UIViewController+Ext.swift
//  Chat
//
//  Created by laijihua on 2018/8/19.
//  Copyright © 2018 laijihua. All rights reserved.
//

import UIKit
import PKHUD

extension UIViewController: NamespaceWrapable {}

extension NamespaceWrapper where Wrapper: UIViewController {

    func showText(_ msg: String,
                  onView: UIView? = nil,
                  delay: TimeInterval = 2.0,
                  completion:((Bool)->Void)? = nil) {
        HUD.flash(.label(msg), onView: onView, delay: delay, completion: completion)
    }
}
