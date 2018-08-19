//
//  String+Ext.swift
//  Chat
//
//  Created by laijihua on 2018/8/19.
//  Copyright © 2018 laijihua. All rights reserved.
//

import UIKit

extension String: NamespaceWrapable {}

extension NamespaceWrapper where Wrapper == String {

    func width(font: UIFont, height: CGFloat) -> CGFloat {
        let labelText = NSString(string: self.wrappedValue)
        let size = CGSize(width: 900, height: height)
        let dict = [NSAttributedStringKey.font: font]
        let strSize = labelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dict, context: nil).size
        return strSize.width
    }

    func height(font: UIFont, width: CGFloat) -> CGFloat {
        let labelText = NSString(string: self.wrappedValue)
        let size = CGSize(width: width, height: 1000)
        let dict = [NSAttributedStringKey.font: font]
        let strSize = labelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dict, context: nil).size
        return strSize.height
    }
}
