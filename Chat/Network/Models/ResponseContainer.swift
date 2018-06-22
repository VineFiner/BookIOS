//
//  ResponseContainer.swift
//  Chat
//
//  Created by laijihua on 2018/6/20.
//  Copyright © 2018 laijihua. All rights reserved.
//

import Foundation

struct ResponseContainer<T: Codable>: Codable {
    var code: Int
    var message: String
    var data: T?

    var isOk: Bool {
        return code == 0
    }
}

extension Data {
    func makeToContainer<D: Codable>() throws -> ResponseContainer<D> {
        return try JSONDecoder().decode(ResponseContainer<D>.self, from: self)
    }

}

