//
//  ViewModelType.swift
//  Chat
//
//  Created by laijihua on 2018/8/19.
//  Copyright © 2018 laijihua. All rights reserved.
//

import Foundation
import URLNavigator

protocol ViewModelType {
    var networkProvider: NetworkManager {get set}
    var navigator: NavigatorType {get set}
}

