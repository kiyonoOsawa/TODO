//
//  TabBarViewController.swift
//  Todo
//
//  Created by 大澤清乃 on 2022/01/22.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 背景の透過
        UITabBar.appearance().backgroundImage = UIImage()
        // 境界線の透過
        UITabBar.appearance().shadowImage = UIImage()
    }

    override func viewWillAppear(_ animated: Bool) {
//        self.tabBarController
    }
}
