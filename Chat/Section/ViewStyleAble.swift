//
//  ViewStyleAble.swift
//  Chat
//
//  Created by laijihua on 2018/8/19.
//  Copyright © 2018 laijihua. All rights reserved.
//

import UIKit
import DynamicColor

protocol ViewStyleAble {
    associatedtype Color  // 颜色
    associatedtype Font   // 字体
    associatedtype Matric  // 尺寸
    associatedtype Other  // 字符串
}

/// app 公有参数
extension ViewStyleAble {
    var gLineViewHeight: CGFloat { return 0.5 }
    var gMargin: CGFloat {return 16.adapter}
    var gVcBgColor: UIColor {return gTableViewColor}
    var gTableViewColor: UIColor { return .white }
    var gButtonHeight: CGFloat {return 44.adapter}
    var gLineColor: UIColor {return UIColor(hexString: "#e3e3e3")}
    var gCellRightArrow: UIImage {return  #imageLiteral(resourceName: "cell_right_arrow_black")}

    var gNavAndStatusBarHeight: CGFloat { return self.gStatusBarHeight + self.gNavbarHeight}
    var gStatusBarHeight: CGFloat {return UIApplication.shared.statusBarFrame.size.height}
    var gTabbarHeight: CGFloat {return 49}
    var gNavbarHeight: CGFloat {return 44}
    var gScreenWidth: CGFloat { return UIScreen.main.bounds.width}
    var gScreenHeight: CGFloat {return UIScreen.main.bounds.height}
    var gButtonTitleFont: UIFont { return UIFont.systemFont(ofSize: 15) }
}

extension CGFloat {
    // iphone6 的适配比例
    /// 写死尺寸的最后
    var adapter: CGFloat {
        get {
            let radio = UIScreen.main.bounds.width / 375
            let scale = UIScreen.main.scale
            let tmp = (self * radio * scale)/scale
            return tmp
        }
    }

}

extension Double {
    var f: CGFloat {
        return CGFloat(self)
    }

    var adapter: CGFloat {
        get {
            return self.f.adapter
        }
    }
}

extension Int {
    var f: CGFloat {
        return CGFloat(self)
    }

    var adapter: CGFloat {
        get {
            return self.f.adapter
        }
    }
}

