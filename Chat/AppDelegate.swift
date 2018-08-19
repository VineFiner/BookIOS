//
//  AppDelegate.swift
//  Chat
//
//  Created by laijihua on 2018/5/31.
//  Copyright © 2018 laijihua. All rights reserved.
//

import UIKit
import SwiftyBeaver
import URLNavigator

let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let provider = NetworkManager() // 服务给 viewmodel
    private var navigator: NavigatorType?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.white

        let navigator = Navigator()
        NavigationMap.initialize(navigator: navigator)

        setupConfig()

        self.navigator = navigator
        self.window = window
        window.rootViewController = createRootViewController(navigator: navigator)
        window.makeKeyAndVisible()
        return true
    }
}

extension AppDelegate {
    private func setupConfig() {
        configNavgationBar()
        setupLogConfig()
        setupTabConfig()
    }

    private func setupTabConfig() {
        let tabBarItem = UITabBarItem.appearance()
        tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.gray], for: .normal)
        tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.black], for: .selected)

        let tabBarApperance = UITabBar.appearance()
        tabBarApperance.backgroundImage =  #imageLiteral(resourceName: "com_tab_bg")
        tabBarApperance.shadowImage = UIImage()
    }

    private func configNavgationBar() {
        let appearance = UINavigationBar.appearance()
        appearance.isTranslucent = false
    }

    private func setupLogConfig() {
        let console = ConsoleDestination()
        let file = FileDestination()
        console.format = "$DHH:mm:ss$d $L $M"
        log.addDestination(console)
        log.addDestination(file)
    }
}

extension AppDelegate {
    private func createRootViewController(navigator: NavigatorType) -> UIViewController {
        if Share.shared.isLogin {
            let tabbar = TabBarController.create(networkProvider: provider, navigator: navigator)
            return tabbar
        } else {
            let viewmodel = LoginViewModel(provider: provider, navigator: navigator)
            let loginVc = LoginViewController(viewModel: viewmodel)
            let nav = NavigationController(rootViewController: loginVc)
            return nav
        }
    }

    private static func shareDelegate() -> AppDelegate {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("appdelegate could not be found")
        }
        return delegate
    }
    
    static var share: AppDelegate { return shareDelegate()}

    static func jumpToHomePageComtroller() {
        let delegate = self.share
        guard let navigator = delegate.navigator, let window = delegate.window else {return}
        window.rootViewController = delegate.createRootViewController(navigator: navigator)
        window.makeKeyAndVisible()
    }
}

extension AppDelegate {
    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }
}

