//
//  MGExeCore.swift
//  MaiGangWang
//
//  Created by laijihua on 12/12/2017.
//  Copyright © 2017 maigangwang. All rights reserved.
//

import Foundation

protocol NamespaceWrapable {
    associatedtype TypeWrapper
    // 对象
    var ext: TypeWrapper {get}
    // 静态方法
    static var ext: TypeWrapper.Type {get}
}

protocol TypeWrapperProtocol {
    associatedtype Wrapper
    var wrappedValue: Wrapper {get}
    init(val: Wrapper)
}

public struct NamespaceWrapper<Wrapper>: TypeWrapperProtocol {
    let wrappedValue: Wrapper
    init(val: Wrapper) {
        self.wrappedValue = val
    }
}

/// 提供默认实现，预想切换
extension NamespaceWrapable {
    var ext: NamespaceWrapper<Self> {
        return NamespaceWrapper(val: self)
    }
    static var ext: NamespaceWrapper<Self>.Type {
        return NamespaceWrapper.self
    }
}
