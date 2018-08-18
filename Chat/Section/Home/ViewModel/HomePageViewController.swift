//
//  HomePageViewController.swift
//  Chat
//
//  Created by laijihua on 2018/6/20.
//  Copyright © 2018 laijihua. All rights reserved.
//

import UIKit

final class HomePageViewController: UIViewController {
    var viewModel: HomePageViewModel
    
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
        loadData()
    }

    func loadData() {
        viewModel.networkProvider.request(ChatApi.userInfo,
                                disposed: rx.disposeBag,
                                success: { (response: Response<User>) in

                                }) { (error) in

                                }
    }

}
