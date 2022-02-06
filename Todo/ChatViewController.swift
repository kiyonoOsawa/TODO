//
//  ChatViewController.swift
//  Todo
//
//  Created by 大澤清乃 on 2021/11/14.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorageUI

class ChatViewController: UIViewController {
    
    @IBOutlet weak var chatTableView: UITableView!
    let db = Firebase.Firestore.firestore()
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference(forURL: "gs://todo-c7ff6.appspot.com")
    var sentGroupId: String = ""
    var addresses: [[String : Any]] = []
    
    //InputAccesoryViewのインスタンス作成
    lazy var chatInputAccesoryView: InputAccesoryView = {
        let view = InputAccesoryView()
        view.delegate = self
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
        //区切り線をなくす
        chatTableView.separatorStyle = .none
        //tabbarを非表示にする
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.tintColor = .black
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        db.collection("groups")
            .document(sentGroupId)
            .collection("messages")
            .order(by: "time", descending: false)
            .addSnapshotListener {(querysnapshot, err) in
                guard let snapshot = querysnapshot else {
                    print(err!)
                    return
                }
                self.addresses.removeAll()
                for doc in snapshot.documents {
                    let messages = doc.data()["chatContent"] as! String
                    let timeStamp = doc.data()["time"] as! Timestamp
                    let userUid = doc.data()["user"] as! String
                    let date: Date = timeStamp.dateValue()
                    
                    self.addresses.append(["chatContent": messages,
                                           "user": userUid,
                                           "time": date])
                    print(self.addresses)
                }
                let indexPath = IndexPath(row: self.addresses.count - 1, section: 0)
                //self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                self.chatTableView.reloadData()
            }
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

extension ChatViewController: InputAccesoryViewDelegate {
    func tappedButton(text: String) {
        guard let user = Auth.auth().currentUser else {return}
        let addData: [String:Any] = ["chatContent": text,
                                     "user": user.uid,
                                     "time": Timestamp(date: Date())]
        db.collection("groups")
            .document(sentGroupId)
            .collection("messages")
            .addDocument(data: addData)
        chatInputAccesoryView.removeText()
    }
    }
    extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatTableViewCell
            let text = addresses[indexPath.row]["chatContent"] as! String
            let chatUid: String = addresses[indexPath.row]["user"] as! String
            let myUid: String = user!.uid
            if chatUid == myUid{
                cell.myMessageText = text
                cell.classmateImageView.image = nil
                cell.myTextView.layer.shadowOpacity = 0.25
                cell.myTextView.layer.shadowColor = UIColor.black.cgColor
                cell.myTextView.layer.shadowOffset = CGSize(width: 2, height: 3)
                cell.myTextView.layer.masksToBounds = false
            } else {
                cell.classmateMessageText = text
                let reference = storageRef.child("userProfile").child("\(chatUid).jpg")
                cell.classmateImageView.sd_setImage(with: reference)
                cell.myTextView.backgroundColor = UIColor(named: "BackColor")
            }
            return cell
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return addresses.count
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            //tableviewセルの高さの最低値
            tableView.estimatedRowHeight = 24
            //textviewの文字列の長さによって高さを自動調節する
            return UITableView.automaticDimension
        }
    }
