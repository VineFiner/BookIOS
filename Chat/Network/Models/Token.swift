//
//  Token.swift
//  Chat
//
//  Created by laijihua on 2018/6/16.
//  Copyright © 2018 laijihua. All rights reserved.
//

import Foundation

struct TokenResult: Codable {
    let refreshToken: String
    let expiresIn: TimeInterval
    let accessToken: String

    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case accessToken = "access_token"
    }
}

