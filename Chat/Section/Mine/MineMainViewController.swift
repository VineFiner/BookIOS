//
//  MineMainViewController.swift
//  Chat
//
//  Created by laijihua on 2018/8/17.
//  Copyright © 2018 laijihua. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import NSObject_Rx

class MineMainViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton(frame: CGRect(x: 0, y: 50, width: 50, height: 50))
        button.setTitle("退出", for: .normal)
        button.backgroundColor = .red;
        button.rx.controlEvent(.touchUpInside).subscribe(onNext: { () in
            Share.shared.token = nil
            AppDelegate.jumpToHomePageComtroller()
        }).disposed(by: rx.disposeBag)

        self.view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
