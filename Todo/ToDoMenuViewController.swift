//
//  ToDoMenuViewController.swift
//  Todo
//
//  Created by 大澤清乃 on 2022/04/16.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ToDoMenuViewController: UIViewController {
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var isComplete: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MenuTabTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let menuPos = self.menuView.layer.position
        self.menuView.layer.position.x = -self.menuView.frame.width
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {self.menuView.layer.position.x = menuPos.x},
                       completion: {bool in})
    }
    //メニュー以外をタップしたら元に戻るようにする
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        for touch in touches {
            if touch.view?.tag == 1 {
                UIView.animate(withDuration: 0.2,
                               delay: 0,
                               options: .curveEaseIn,
                               animations: {self.menuView.layer.position.x = -self.menuView.frame.width},
                               completion: {bool in self.dismiss(animated: true, completion: nil)})
            }
        }
    }
}

extension ToDoMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuTabTableViewCell
        let menuArray: [String] = ["完了", "未完了"]
        cell.titleLabel.text = menuArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //どのcellを選択したか判別して、isCompleteを切り替える
        switch indexPath.row {
        case 0: isComplete = true
        case 1: isComplete = false
        default:
            print("error")
        }
        //選択解除
        tableView.deselectRow(at: indexPath, animated: true)
        //前のviewcontrollerを取得してisCompleteの値を渡す
        let preNC = self.presentingViewController as! UINavigationController
        let preVC = preNC.viewControllers[preNC.viewControllers.count - 1] as! MyTodoViewController
        preVC.isComplete = self.isComplete
        preVC.configureTimeArray()
        preVC.OuterCollectionView.reloadData()
        
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {self.menuView.layer.position.x = -self.menuView.frame.width},
                       completion: {bool in self.dismiss(animated: true, completion: nil)})
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

