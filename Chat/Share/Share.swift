//
//  Share.swift
//  Chat
//
//  Created by laijihua on 2018/6/16.
//  Copyright © 2018 laijihua. All rights reserved.
//

import Foundation

private let userDefault = UserDefaults.standard

/// 需要定义规范使用这个单例
final class Share {
    static let shared:Share = Share()

    init() {}

    var token: Token? {
        set {
            userDefault.set(object: newValue, forKey: "tokenKey")
            userDefault.synchronize()
        }
        get {
            let reulst = userDefault.get(objectType: Token.self, forKey: "tokenKey")
            return reulst
        }
    }

    var user: User? {
        set {
            userDefault.set(object: newValue, forKey: "userKey")
            userDefault.synchronize()
        }
        get {
            let result = userDefault.get(objectType: User.self, forKey: "userKey")
            return result
        }
    }

    

    var isLogin: Bool {
        guard let _ = user?.id, let token = token?.accessToken else {
            return false
        }
        return token.count > 0
    }
}

extension Share { }
