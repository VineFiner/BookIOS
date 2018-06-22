//
//  Plugins.swift
//  Chat
//
//  Created by laijihua on 2018/6/20.
//  Copyright © 2018 laijihua. All rights reserved.
//

import Moya
import Foundation

protocol CahchePoliyGettable {
    var cachePolicy: URLRequest.CachePolicy {get}
}

/// 缓存策略
final class ChachePolicyPlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        if let cachePliyGettable = target as? CahchePoliyGettable {
            var mutableRequest = request
            mutableRequest.cachePolicy = cachePliyGettable.cachePolicy
            return mutableRequest
        }
        return request
    }
}
