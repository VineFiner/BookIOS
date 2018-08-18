//
//  HomePageViewModel.swift
//  Chat
//
//  Created by laijihua on 2018/8/19.
//  Copyright © 2018 laijihua. All rights reserved.
//

import Foundation
import URLNavigator

final class HomePageViewModel: ViewModelType {

    var networkProvider: NetworkManager
    var navigator: NavigatorType

    init(provider: NetworkManager, navigator: NavigatorType) {
        self.networkProvider = provider
        self.navigator = navigator
    }
}
