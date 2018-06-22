//
//  HomePageViewController.swift
//  Chat
//
//  Created by laijihua on 2018/6/20.
//  Copyright © 2018 laijihua. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {
    var networkProvider: NetworkManager
    
    init(networkProvider: NetworkManager) {
        self.networkProvider = networkProvider
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
        networkProvider.info(disposed: rx.disposeBag,
                             success: { [weak self](res) in
                                guard let _ = self, let result = res else { return }
                                if result.isOk {
                                    Share.shared.user = result.data
                                }
                            }) { [weak self](error) in

                            }
    }

}
