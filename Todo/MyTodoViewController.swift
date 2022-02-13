//
//  MyTodoViewController.swift
//  Todo
//
//  Created by 大澤清乃 on 2022/01/16.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseStorageUI
import FirebaseAuth

class MyTodoViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var OuterCollectionView: UICollectionView!
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var viewWidth: CGFloat = 0.0
    var timeArray = [String]()
    var addresses: [[String : Any]] = []
    var date = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewWidth = view.frame.width
        OuterCollectionView.delegate = self
        OuterCollectionView.dataSource = self
        OuterCollectionView.register(UINib(nibName: "OuterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OuterCell")
        OuterCollectionView.allowsSelection = true
        OuterCollectionView.isUserInteractionEnabled = true
        
        guard let user = user else { return }
        
        db.collection("users")
            .document(user.uid)
            .collection("tasks")
            .order(by: "time", descending: false)
            .addSnapshotListener{QuerySnapshot, Error in
                guard let querySnapshot = QuerySnapshot else {return}
                
                self.addresses.removeAll()
                for doc in querySnapshot.documents{
                    let timeStamp = doc.data()["time"] as! Timestamp
                    let day = doc.data()["day"] as! String
                    let content = doc.data()["content"] as! String
                    let rgbRed = doc.data()["redcolor"] as! CGFloat
                    let rgbGreen = doc.data()["greencolor"] as! CGFloat
                    let rgbBlue = doc.data()["bluecolor"] as! CGFloat
                    let alpha = doc.data()["alpha"] as! CGFloat
                    
                    let date: Date = timeStamp.dateValue()
                    
                    self.timeArray.append(day)
                    let orderedSet: NSOrderedSet = NSOrderedSet(array: self.timeArray)
                    self.timeArray = orderedSet.array as! [String]
                    
                    self.addresses.append(
                        ["time": date,
                         "day": day,
                         "content": content,
                         "redcolor": rgbRed,
                         "greencolor": rgbGreen,
                         "bluecolor": rgbBlue,
                         "alpha": alpha,
                         "documentID": doc.documentID]
                    )
                    print("データ取り出し\(doc)")
                }
            }
        self.OuterCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.OuterCollectionView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDateTodo"{
            let vc = segue.destination as! DateTodoViewController
            vc.addresses = self.addresses
            vc.date = self.date
        }
    }
}

extension MyTodoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = OuterCollectionView.dequeueReusableCell(withReuseIdentifier: "OuterCell", for: indexPath) as! OuterCollectionViewCell
        
        cell.layer.cornerRadius = 12
        cell.layer.shadowOpacity = 0.25
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.masksToBounds = false
        
        cell.dateLabel.text = timeArray[indexPath.row]
        cell.configureCell(contentArray: addresses, date: timeArray[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let space: CGFloat = 56
        let cellWidth: CGFloat = viewWidth - space
        let cellHeight: CGFloat = 160
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        date = timeArray[indexPath.row]
        self.performSegue(withIdentifier: "toDateTodo", sender: nil)
    }
    
}
