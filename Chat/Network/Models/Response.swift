//
//  ResponseContainer.swift
//  Chat
//
//  Created by laijihua on 2018/6/20.
//  Copyright © 2018 laijihua. All rights reserved.
//

import Foundation

struct Response<T: Codable>: Codable {
    typealias Data = T
    
    var status: Int
    var message: String
    var data: Data?

    var isOk: Bool {
        return status == 0
    }
}

