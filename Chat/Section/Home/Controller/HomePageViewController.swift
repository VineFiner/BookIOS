//
//  HomePageViewController.swift
//  Chat
//
//  Created by laijihua on 2018/6/20.
//  Copyright © 2018 laijihua. All rights reserved.
//

import UIKit
import Pageboy

/// MARK: Style
extension HomePageViewController: ViewStyleAble {
    struct Color {

    }

    struct Font {

    }

    struct Matric {

    }

    struct Other {

    }
}

/// MARK: - class
final class HomePageViewController: PageboyViewController {
    var viewModel: HomePageViewModel

    private let titles: [TitleType] = [.hot, .user, .book, .category]

    private lazy var navTitleView: PageTitleView = {
        let frame = CGRect(x: 0, y: 0, width: gScreenWidth, height: 44)
        let titls = self.titles.map({$0.title})
        let pageTitleView = PageTitleView(frame: frame, titles: titls, click: { [weak self](index) in
            self?.pageTitleClick(index: index)
        })
        pageTitleView.searchAction = { [weak self] in
            self?.gotoSearch(searchType: .book)
        }
        return pageTitleView
    }()

    private lazy var pageControllers: [ChildBaseViewController] = {
        let vcs = self.titles.map { (type) -> ChildBaseViewController in
            let vc = type.vcType.init()
            vc.type = type
            return vc
        }
        return vcs
    }()
    
    init(viewModel: HomePageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setup()
    }

    private func setup() {
        dataSource = self
        delegate = self
        self.navigationItem.titleView = self.navTitleView
    }
}

// MARK: - Action
extension HomePageViewController {
    func pageTitleClick(index: Int) {

    }

    func gotoSearch(searchType: SearchType) {

    }

    private func switchTitileView(index: Int) {
        guard self.navTitleView.index != index else {return}
        self.navTitleView.index = index
    }
}

extension HomePageViewController: PageboyViewControllerDataSource {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return pageControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return pageControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}

extension HomePageViewController: PageboyViewControllerDelegate {
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               willScrollToPageAt index: Int,
                               direction: PageboyViewController.NavigationDirection,
                               animated: Bool) {
    }

    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollTo position: CGPoint,
                               direction: PageboyViewController.NavigationDirection,
                               animated: Bool) {

    }

    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollToPageAt index: Int,
                               direction: PageboyViewController.NavigationDirection,
                               animated: Bool) {

        self.switchTitileView(index: index)

    }

    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didReloadWith currentViewController: UIViewController,
                               currentPageIndex: PageboyViewController.PageIndex) {
    }
}


// MARK: 类型定义
extension HomePageViewController {
    class ChildBaseViewController: UIViewController {
        var type: TitleType!
    }

    enum TitleType {
        case hot
        case user
        case book
        case category

        var title: String {
            switch self {
            case .hot: return "热榜"
            case .user: return "新用户"
            case .book: return "新书"
            case .category: return "分类"
            }
        }
        var vcType: ChildBaseViewController.Type {
            return ChildViewController.self
        }
    }
}

extension HomePageViewController {
    final class ChildViewController: ChildBaseViewController {

    }
}
