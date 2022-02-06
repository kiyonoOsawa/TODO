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

class MyTodoViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var OuterCollectionView: UICollectionView!
    
    var viewWidth: CGFloat = 0.0
    var timeArray = [String]()
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewWidth = view.frame.width
        OuterCollectionView.delegate = self
        OuterCollectionView.dataSource = self
        OuterCollectionView.register(UINib(nibName: "OuterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OuterCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if userDefaults.object(forKey: "time") != nil{
            timeArray = userDefaults.object(forKey: "time") as! [String]
            print(timeArray)
        }
        viewWidth = view.frame.width
        self.OuterCollectionView.reloadData()
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
        cell.configureCell(collectionName: timeArray[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let space: CGFloat = 36
        let cellWidth: CGFloat = viewWidth - space
        let cellHeight: CGFloat = 160
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    
}
