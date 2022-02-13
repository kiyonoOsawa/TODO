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
    var taskArray: [[String:Any]] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal //横スクロール
        self.layer.cornerRadius = 12
        InnerCollectionView.collectionViewLayout = layout
        InnerCollectionView.delegate = self
        InnerCollectionView.dataSource = self
        InnerCollectionView.allowsSelection = false
        InnerCollectionView.isUserInteractionEnabled = false
        InnerCollectionView.isScrollEnabled = true
        InnerCollectionView.register(UINib(nibName: "InnerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "InnerCell")
    }
    
    func configureCell(contentArray: [[String:Any]], date: String) {
        taskArray.removeAll()
        for content in contentArray{
            let contentDate = content["day"] as! String
            if contentDate == date{
                taskArray.append(content)
                print(taskArray)
            }
            self.InnerCollectionView.reloadData()
        }
    }

}

extension OuterCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = InnerCollectionView.dequeueReusableCell(withReuseIdentifier: "InnerCell", for: indexPath) as! InnerCollectionViewCell
        
        let rgbRed = taskArray[indexPath.row]["redcolor"] as! CGFloat
        let rgbBlue = taskArray[indexPath.row]["bluecolor"] as! CGFloat
        let rgbGreen = taskArray[indexPath.row]["greencolor"] as! CGFloat
        let alpha = taskArray[indexPath.row]["alpha"] as! CGFloat
        
        cell.backgroundColor = UIColor(red: rgbRed, green: rgbGreen, blue: rgbBlue, alpha: alpha)
        cell.todoLabel.text = taskArray[indexPath.row]["content"] as? String

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
