//
//  AppDelegate.swift
//  Chat
//
//  Created by laijihua on 2018/5/31.
//  Copyright © 2018 laijihua. All rights reserved.
//

import UIKit
import SwiftyBeaver
let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let provider = NetworkManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.white
        setupConfig()
        self.window = window

        window.rootViewController = createRootViewController()
        window.makeKeyAndVisible()
        return true
    }
}

extension AppDelegate {
    private func setupConfig() {
        configNavgationBar()
        setupLogConfig()
    }

    private func setupLogConfig() {
        let console = ConsoleDestination()
        let file = FileDestination()
        console.format = "$DHH:mm:ss$d $L $M"
        log.addDestination(console)
        log.addDestination(file)
    }

    private func configNavgationBar() {
        let appearance = UINavigationBar.appearance()
        appearance.isTranslucent = false
    }
}

extension AppDelegate {
    private func createRootViewController() -> UIViewController {
        if Share.shared.isLogin {
            let hpVc = HomePageViewController(networkProvider: provider)
            let nav = UINavigationController(rootViewController: hpVc)
            return nav
        } else {
            let loginVc = LoginViewController(networkProvider: provider)
            let nav = UINavigationController(rootViewController: loginVc)
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
        let hpVc = HomePageViewController(networkProvider: delegate.provider)
        let nav = UINavigationController(rootViewController: hpVc)
        delegate.window?.rootViewController = nav
        delegate.window?.makeKeyAndVisible()
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

