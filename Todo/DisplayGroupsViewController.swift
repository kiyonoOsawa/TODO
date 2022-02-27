//
//  DisplayGroupsViewController.swift
//  Todo
//
//  Created by 大澤清乃 on 2021/11/14.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseStorageUI
import FirebaseAuth

class DisplayGroupsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var logOutButton: UIButton!
    
    let db = Firebase.Firestore.firestore()
    let auth = Auth.auth()
    let storageRef = Storage.storage().reference(forURL: "gs://todo-c7ff6.appspot.com")
    var addresses: [[String : String]] = []
    var groupId: String!
    var viewWidth: CGFloat! // viewの横幅
    var viewHeight: CGFloat! // viewの縦幅
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewWidth = view.frame.width
        
        self.tabBarController?.tabBar.isHidden = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil),forCellWithReuseIdentifier: "cell")
        
        db.collection("groups")
            .addSnapshotListener{ (querysnapshot, err) in
                guard let snapshot = querysnapshot else {
                    
                    print(err!)
                    return
                }
                
                //一旦データを削除
                self.addresses.removeAll()
                
                for doc in snapshot.documents{
                    let roomName = doc.data()["roomName"] as! String
                    let roomNumber = doc.data()["roomNumber"] as! String
                    let docID = doc.documentID
                    //下から用意している配列に追加
                    self.addresses.append(["roomName": roomName,
                                           "docID": docID,
                                           "roomNumber": roomNumber])
                    self.collectionView.reloadData()
                }
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        if segue.identifier == "toChat"{
            let vc = segue.destination as! ChatViewController
            vc.sentGroupId = self.groupId
            print("groupId: \(groupId)")
        }
    }
    
    @IBAction func tappedLogOut() {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "firstView")
            nextVC?.modalPresentationStyle = .fullScreen
            self.present(nextVC!, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func addGroupAlert(indexPath: IndexPath){
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.title = "Groupに参加"
        alert.message = "GroupIDを入力"
        
        alert.addTextField(configurationHandler: {(textField) -> Void in
            textField.delegate = self
            
        })
        
        var textField = UITextField()
        var groupnumber = addresses[indexPath.row]["roomNumber"]!

        alert.addAction(
            UIAlertAction(
                title: "参加",
                style: .default,
                handler: { [self](action) -> Void in
                    if textField.text == groupnumber {
                        self.groupId = self.addresses[indexPath.row]["docID"]!
                        self.performSegue(withIdentifier: "toChat", sender: nil)
                    } else {
                        let alert = UIAlertController(title: nil, message: "GroupIDが違います", preferredStyle: .alert)
                    }
                    self.hello(action.title!)
                })
        )
        
        alert.addAction(
            UIAlertAction(
                title: "キャンセル",
                style: .cancel,
                handler: {(action) -> Void in
                    self.hello(action.title!)
                })
        )
        
        self.present(
            alert,
            animated: true,
            completion: {
                print("アラートが表示された")
            })
    }
    
    func hello(_ msg: String) {
        print(msg)
    }
}

extension DisplayGroupsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        addresses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.layer.cornerRadius = 12
        cell.layer.shadowOpacity = 0.4 // 影の濃さ
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 2, height: 2)
        cell.layer.masksToBounds = false
        cell.groupName.text = addresses[indexPath.row]["roomName"]
        
        let groupName: String = addresses[indexPath.row]["roomName"]!
        let reference = storageRef.child("groupProfile").child("\(groupName).jpg")
        cell.groupImage.sd_setImage(with: reference)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let space: CGFloat = 50
        let cellWidth: CGFloat = viewWidth - space
        let cellHeight: CGFloat = 110
        return CGSize(width: cellWidth, height: cellHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.addGroupAlert(indexPath: indexPath)
    }
}
