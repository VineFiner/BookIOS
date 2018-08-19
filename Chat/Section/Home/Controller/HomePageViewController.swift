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
        self.title = "首页"
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
