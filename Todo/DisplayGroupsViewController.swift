//
//  DisplayGroupsViewController.swift
//  Todo
//
//  Created by 大澤清乃 on 2021/11/14.
//

import UIKit
import Firebase
import FirebaseFirestore

class DisplayGroupsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let db = Firebase.Firestore.firestore()
    var addresses: [[String : String]] = []
    var viewWidth: CGFloat! // viewの横幅
    var viewHeight: CGFloat! // viewの縦幅
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewWidth = view.frame.width
        
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
                    //下から用意している配列に追加
                    self.addresses.append(["roomName": roomName])
                    self.collectionView.reloadData()
                }
            }
    }
}

extension DisplayGroupsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        addresses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.layer.cornerRadius = 12
        cell.layer.shadowOpacity = 0.25 // 影の濃さ
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 2, height: 3)
        cell.layer.masksToBounds = false
        cell.groupName.text = addresses[indexPath.row]["roomName"]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let space: CGFloat = 36
        let cellWidth: CGFloat = viewWidth - space
        let cellHeight: CGFloat = 130
        return CGSize(width: cellWidth, height: cellHeight)
        
    }
}
