//
//  ChatApi.swift
//  Chat
//
//  Created by laijihua on 2018/6/16.
//  Copyright © 2018 laijihua. All rights reserved.
//

import Foundation
import Moya

protocol ChatAPIType {
    var addAuth: Bool {get}
}

enum ChatApi {
    case login(email: String, password: String)
    case registe(name: String, email: String, password: String)
    case userInfo
    case tokenRefresh(refreshToken: String)
}

extension ChatApi: TargetType, ChatAPIType {

    var addAuth: Bool {
        switch self {
        case .login, .registe:
            return false
        default: return true
        }
    }

    var baseURL: URL {
        guard let url = URL(string: "http://192.168.100.9:8988") else {
            fatalError("baseURL could not be configured")
        }
        return url
    }

    var path: String {
        switch self {
        case .login:
            return "api/users/login"
        case .registe:
            return "api/users/register"
        case .userInfo:
            return "api/account/info"
        case .tokenRefresh:
            return "api/token/refresh"
        }
    }

    var method: Moya.Method {
        switch self {
        case .login,
             .registe,
             .tokenRefresh:
            return .post
        case .userInfo:
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case let .login(email, password):
            return .requestJSONEncodable(["email": email, "password": password])
        case let .registe(name, email, password):
            return .requestJSONEncodable(["name":name, "password": password, "email": email])
        case .userInfo:
            return .requestPlain
        case let .tokenRefresh(refreshToken):
            return .requestJSONEncodable(["refresh_token": refreshToken])
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}

// MARK: - 缓存策略
extension ChatApi: CahchePoliyGettable {
    var cachePolicy: URLRequest.CachePolicy {
        return URLRequest.CachePolicy.reloadIgnoringCacheData
    }
}

// MARK: - Auth
extension ChatApi: AccessTokenAuthorizable {
    var authorizationType: AuthorizationType {
        if self.addAuth {
            return .bearer
        } else {
            return .none
        }
    }
}

