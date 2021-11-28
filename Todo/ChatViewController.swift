//
//  ChatViewController.swift
//  Todo
//
//  Created by 大澤清乃 on 2021/11/14.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var chatTableView: UITableView!
    
    //InputAccesoryViewのインスタンス作成
    lazy var chatInputAccesoryView: InputAccesoryView = {
        let view = InputAccesoryView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width , height: 100)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        //選択不可にする
        chatTableView.allowsSelection = false
        //背景色の設定
//        chatTableView.backgroundColor = UIColor(named: "DarkMainColor")
        //区切り線をなくす
        chatTableView.separatorStyle = .none
        //tabbarを非表示にする
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    //inputAccessryViewとして表示される(実際に表示)
    override var inputAccessoryView: UIView?{
        get{
            return chatInputAccesoryView
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatTableViewCell
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //tableviewセルの高さの最低値
        tableView.estimatedRowHeight = 24
        //textviewの文字列の長さによって高さを自動調節する
        return UITableView.automaticDimension
    }
}
