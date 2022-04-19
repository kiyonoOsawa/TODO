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
    @IBOutlet weak var HomeCollectionView: UICollectionView!
    @IBOutlet weak var taskCountLabel: UILabel!
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var taskArray: [[String : Any]] = []
    var day = String()
    weak var delegate: OuterCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        HomeCollectionView.layer.cornerRadius = 10
        HomeCollectionView.collectionViewLayout = layout
        HomeCollectionView.delegate = self
        HomeCollectionView.dataSource = self
        HomeCollectionView.allowsSelection = false
        HomeCollectionView.isUserInteractionEnabled = false
        HomeCollectionView.register(UINib(nibName: "HomeInnerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "InnerCell")
    }
    
    func configureCell(contentArray: [[String : Any]], date: String) {
        taskArray.removeAll()
        for content in contentArray{
            let contentDate = content["day"] as! String
            if contentDate == date{
                day = date
                taskArray.append(content)
                print(taskArray)
            }
            self.HomeCollectionView.reloadData()
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
        let cell = HomeCollectionView.dequeueReusableCell(withReuseIdentifier: "InnerCell", for: indexPath) as! HomeInnerCollectionViewCell
        
        let rgbRed = taskArray[indexPath.row]["red"] as! CGFloat
        let rgbBlue = taskArray[indexPath.row]["blue"] as! CGFloat
        let rgbGreen = taskArray[indexPath.row]["green"] as! CGFloat
        let alpha = taskArray[indexPath.row]["alpha"] as! CGFloat
        
        cell.backgroundColor = UIColor(red: rgbRed, green: rgbGreen, blue: rgbBlue, alpha: alpha)
//        cell.todoLabel.text = taskArray[indexPath.row]["content"] as? String
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 33, height: 33)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
    
    
    
}
