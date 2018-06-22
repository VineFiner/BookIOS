//
//  UserDefaults+Ext.swift
//  Chat
//
//  Created by laijihua on 2018/6/20.
//  Copyright © 2018 laijihua. All rights reserved.
//

import Foundation

extension UserDefaults {
    func set<T: Codable>(object: T, forKey: String) {
        let jsonData = try? JSONEncoder().encode(object)
        set(jsonData, forKey: forKey)
    }

    func get<T: Codable>(objectType: T.Type, forKey: String) -> T? {
        guard let reuslt = value(forKey: forKey) as? Data else {
            return nil
        }
        let result = try? JSONDecoder().decode(objectType, from: reuslt)
        return result
    }
}
