//
//  OuterCollectionViewCell.swift
//  Todo
//
//  Created by 大澤清乃 on 2022/01/30.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class OuterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var InnerCollectionView: UICollectionView!
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var addresses: [[String:Any]] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal //横スクロール
        InnerCollectionView.collectionViewLayout = layout
        InnerCollectionView.delegate = self
        InnerCollectionView.dataSource = self
        InnerCollectionView.register(UINib(nibName: "InnerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "InnerCell")
    }
    
    func configureCell(collectionName: String) {
        
        guard let user = user else { return }

        db.collection("users")
            .document(user.uid)
            .collection(collectionName)
            .addSnapshotListener { QuerySnapshot, Error in
                
                guard let snapshot = QuerySnapshot else {return}
                self.addresses.removeAll()
                for doc in snapshot.documents{
                    let timeStamp = doc.data()["time"] as! Timestamp
                    let content = doc.data()["content"] as! String
                    let rgbRed = doc.data()["red"] as! CGFloat
                    let rgbGreen = doc.data()["green"] as! CGFloat
                    let rgbBlue = doc.data()["blue"] as! CGFloat
                    let alpha = doc.data()["alpha"] as! CGFloat
                    
                    let date: Date = timeStamp.dateValue()
                    
                    self.addresses.append(
                        ["time": date,
                         "content": content,
                         "red": rgbRed,
                         "green": rgbGreen,
                         "blue": rgbBlue,
                         "alpha": alpha]
                    )
                }
                self.InnerCollectionView.reloadData()
            }
    }

}

extension OuterCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = InnerCollectionView.dequeueReusableCell(withReuseIdentifier: "InnerCell", for: indexPath) as! InnerCollectionViewCell
        
        let rgbRed = addresses[indexPath.row]["red"] as! CGFloat
        let rgbBlue = addresses[indexPath.row]["blue"] as! CGFloat
        let rgbGreen = addresses[indexPath.row]["green"] as! CGFloat
        let alpha = addresses[indexPath.row]["alpha"] as! CGFloat
        
        cell.backgroundColor = UIColor(red: rgbRed, green: rgbGreen, blue: rgbBlue, alpha: alpha)
        cell.todoLabel.text = addresses[indexPath.row]["content"] as? String

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 12, bottom: 8, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    
    
}
