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

protocol OuterCollectionViewCellDelegate: AnyObject {
    func tappedCell(date: String)
}
class OuterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var HomeInnerCollectionViewCell: UICollectionView!
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var taskArray: [[String:Any]] = []
    var day = String()
    weak var delegate: OuterCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal //横スクロール
        self.layer.cornerRadius = 4
        HomeInnerCollectionViewCell.layer.cornerRadius = 4
        HomeInnerCollectionViewCell.collectionViewLayout = layout
        HomeInnerCollectionViewCell.delegate = self
        HomeInnerCollectionViewCell.dataSource = self
        HomeInnerCollectionViewCell.allowsSelection = false
        HomeInnerCollectionViewCell.isUserInteractionEnabled = false
        HomeInnerCollectionViewCell.isScrollEnabled = true
        HomeInnerCollectionViewCell.register(UINib(nibName: "HomeInnerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "InnerCell")
    }
    
    func configureCell(contentArray: [[String:Any]], date: String) {
        taskArray.removeAll()
        for content in contentArray{
            let contentDate = content["day"] as! String
            if contentDate == date{
                day = date
                taskArray.append(content)
                print(taskArray)
            }
            self.HomeInnerCollectionViewCell.reloadData()
        }
    }
    
}

extension OuterCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.tappedCell(date: self.day)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = HomeInnerCollectionViewCell.dequeueReusableCell(withReuseIdentifier: "InnerCell", for: indexPath) as! HomeInnerCollectionViewCell
        
        let rgbRed = taskArray[indexPath.row]["redcolor"] as! CGFloat
        let rgbBlue = taskArray[indexPath.row]["bluecolor"] as! CGFloat
        let rgbGreen = taskArray[indexPath.row]["greencolor"] as! CGFloat
        let alpha = taskArray[indexPath.row]["alpha"] as! CGFloat
        
        cell.backgroundColor = UIColor(red: rgbRed, green: rgbGreen, blue: rgbBlue, alpha: alpha)
        cell.todoLabel.text = taskArray[indexPath.row]["content"] as? String
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 4 - 45, height: collectionView.frame.size.width / 4 - 45)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    
    
}
