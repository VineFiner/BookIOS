//
//  TabBarController.swift
//  Chat
//
//  Created by laijihua on 2018/8/17.
//  Copyright © 2018 laijihua. All rights reserved.
//

import UIKit
import URLNavigator

final class TabBarController: UITabBarController {

    var networkProvider: NetworkManager
    var navigator: NavigatorType

    init(networkProvider: NetworkManager, navigator: NavigatorType) {
        self.networkProvider = networkProvider
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
//        let homePageVc = HomePageViewController(networkProvider: networkProvider)
//        let homePageNav =  UINavigationController(rootViewController: homePageVc)

    }
}
