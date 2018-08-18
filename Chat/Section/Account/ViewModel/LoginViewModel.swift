//
//  LoginViewModel.swift
//  Chat
//
//  Created by laijihua on 2018/8/17.
//  Copyright © 2018 laijihua. All rights reserved.
//

import Foundation
import RxSwift
import URLNavigator


final class LoginViewModel: ViewModelType {

    var networkProvider: NetworkManager
    var navigator: NavigatorType

    init(provider: NetworkManager, navigator: NavigatorType) {
        self.networkProvider = provider
        self.navigator = navigator
    }
}
