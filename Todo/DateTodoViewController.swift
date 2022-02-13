//
//  DateTodoViewController.swift
//  Todo
//
//  Created by 大澤清乃 on 2022/02/13.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class DateTodoViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var addresses: [[String : Any]] = []
    var date = String()
    var taskArray: [[String : Any]] = []
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "InnerCollectionViewcell", bundle: nil), forCellWithReuseIdentifier: "InnerCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addComponent()
    }
    
    func addComponent(){
        taskArray.removeAll()
        for content in addresses{
            let contentDate = content["date"] as! String
            if contentDate == date {
                taskArray.append(content)
            }
        }
        collectionView.reloadData()
    }
}

extension DateTodoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        taskArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InnerCell", for: indexPath) as! InnerCollectionViewCell
        let rgbRed = taskArray[indexPath.row]["red"] as! CGFloat
        let rgbBlue = taskArray[indexPath.row]["blue"] as! CGFloat
        let rgbGreen = taskArray[indexPath.row]["green"] as! CGFloat
        let alpha = taskArray[indexPath.row]["alpha"] as! CGFloat
        
        cell.backgroundColor = UIColor(red: rgbRed, green: rgbGreen, blue: rgbBlue, alpha: alpha)
        cell.todoLabel.text = taskArray[indexPath.row]["content"] as? String
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedDocID = addresses[indexPath.row]["documentID"] as! String
        guard let user = user else{ return }
        db.collection("users")
            .document(user.uid)
            .collection("tasks")
            .document(selectedDocID)
            .delete(){err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    self.taskArray.remove(at: indexPath.row)
                    self.collectionView.reloadData()
                    
                    if self.taskArray.isEmpty {
                        let preNC = self.navigationController!
                        let preVC = preNC.viewControllers[preNC.viewControllers.count - 2] as! MyTodoViewController
                        
                        preVC.timeArray.removeAll(where: {$0 == self.date})
                    }
                }
            }
    }
}