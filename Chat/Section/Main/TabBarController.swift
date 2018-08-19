//
//  TabBarController.swift
//  Chat
//
//  Created by laijihua on 2018/8/17.
//  Copyright © 2018 laijihua. All rights reserved.
//

import UIKit
import URLNavigator
import CYLTabBarController
import BHBPopView

final class TabBarController: CYLTabBarController {

    struct Const {
        static var preSelectIndex: Int = 0
    }

    private static func createTabBarViewControllers(networkProvider: NetworkManager, navigator: NavigatorType) -> [UINavigationController] {
        let homeNavController: UINavigationController = {
            let viewModel = HomePageViewModel(provider: networkProvider, navigator: navigator)
            let homeViewController = HomePageViewController(viewModel: viewModel)
            return NavigationController(rootViewController: homeViewController)
        }()

        let wishNavController: UINavigationController = {
            let wishViewController = WishMainViewController()
            return NavigationController(rootViewController: wishViewController)
        }()

        let mineNavController: UINavigationController = {
            let mineVc = MineMainViewController()
            return NavigationController(rootViewController: mineVc)
        }()

        let newsNavController: UINavigationController = {
            let newsVc = NewsMainViewController()
            return NavigationController(rootViewController: newsVc)
        }()

        return [homeNavController, wishNavController, newsNavController, mineNavController]
    }

    private static func tabBarItemsAttributesForController() ->  [[String : String]] {
        let tabBarItemOne = [CYLTabBarItemTitle:"首页",
                             CYLTabBarItemImage:"tab_home_normal",
                             CYLTabBarItemSelectedImage:"tab_home_highlight"]

        let tabBarItemTwo = [CYLTabBarItemTitle:"心愿",
                             CYLTabBarItemImage:"tab_find_normal",
                             CYLTabBarItemSelectedImage:"tab_find_highlight"]

        let tabBarItemFour = [CYLTabBarItemTitle:"我的",
                              CYLTabBarItemImage:"tab_profile_normal",
                              CYLTabBarItemSelectedImage:"tab_profile_highlight"]

        let tabBarItemThree = [CYLTabBarItemTitle:"消息",
                               CYLTabBarItemImage:"tab_news_normal",
                               CYLTabBarItemSelectedImage:"tab_news_highlight"]

        let tabBarItemsAttributes = [tabBarItemOne,tabBarItemTwo,tabBarItemThree, tabBarItemFour]
        return tabBarItemsAttributes
    }

    static func create(networkProvider: NetworkManager, navigator: NavigatorType)  -> TabBarController {
        let viewControllers = createTabBarViewControllers(networkProvider: networkProvider, navigator: navigator)
        let attributes = tabBarItemsAttributesForController()
        PlusButton.register()
        let defaultTabbarVc = TabBarController(viewControllers: viewControllers, tabBarItemsAttributes: attributes)
        return defaultTabbarVc!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension TabBarController {
    class PlusButton: CYLPlusButton, CYLPlusButtonSubclassing {
        static func plusButton() -> Any! {
            let button = PlusButton()
            button.setImage(UIImage(named: "post_normal"), for: .normal)
            button.adjustsImageWhenHighlighted = false
            button.sizeToFit()
            return button
        }

        static func multiplier(ofTabBarHeight tabBarHeight: CGFloat) -> CGFloat {
            return 0.3
        }

        static func constantOfPlusButtonCenterYOffset(forTabBarHeight tabBarHeight: CGFloat) -> CGFloat {
            return -5
        }

        static func plusChildViewController() -> UIViewController! {
            let vc = UIViewController()
            let nav = NavigationController(rootViewController: vc)
            self.viewController = vc
            return nav
        }

        static func indexOfPlusButtonInTabBar() -> UInt {
            return 2
        }

        static var viewController: UIViewController?

        static func shouldSelectPlusChildViewController() -> Bool {
            presentView()
            return false
        }

        enum ItemName: String {
            case post = "发布书籍"
            case book = "心愿书单"
            case suggest = "改进建议"

            var image: String {
                switch self {
                case .post:
                    return "images.bundle/com_mid_add"
                case .book:
                    return "images.bundle/com_mid_love"
                case .suggest:
                    return "images.bundle/tabbar_compose_review"
                }
            }

            var things:(image: String, title: String) {
                return (image: self.image, title: self.rawValue)
            }
        }

        static private func presentView() {
            guard let window = UIApplication.shared.keyWindow else {return}
            BHBPopView.show(to: window, andImages: [ ItemName.post.image, ItemName.book.image, ItemName.suggest.image], andTitles: [ItemName.post.rawValue, ItemName.book.rawValue, ItemName.suggest.rawValue]) { (item) in
                guard let tmp = item, let key = ItemName.init(rawValue: tmp.title), let vc = self.viewController else {return }

                if let selectVc = vc.tabBarController?.selectedViewController, let selectNav = selectVc as? UINavigationController{
                    selectNav.pushViewController(getPresentViewController(name: key), animated: true)
                }
            }
        }

        static func getPresentViewController(name: ItemName) -> UIViewController {
//            switch name {
//            case .post:
//                let scanVc = BookScannerViewController()
//                return scanVc
//            case .book:
//                let addVc = FindAddWishViewController()
//                return addVc
//            case .suggest:
//                let fdVc = FeedbackViewController()
//                return fdVc
//            }
            return UIViewController()
        }
    }

}
