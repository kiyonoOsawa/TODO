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

        tabBar.items![0].image = UIImage(named: "todo")!
    }

}
