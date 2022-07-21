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
    @IBOutlet weak var dateLabel: UILabel!
    
    var addresses: [[String : Any]] = []
    var date = String()
    var timeArray = [String]()
    var taskArray: [[String : Any]] = []
    var completeArray: [[String : Any]] = []
    var isComplete = Bool()
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "InnerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "InnerCell")
        self.navigationController?.navigationBar.tintColor = UIColor(red: 15/255, green: 22/255, blue: 51/255, alpha: 1.0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addComponent()
    }
    
    func addComponent(){
        taskArray.removeAll()
        for content in addresses{
            let contentDate = content["day"] as! String
            if contentDate == date {
                taskArray.append(content)
            } else if contentDate == date && isComplete == true{
                completeArray.append(content)
            }
        }
        collectionView.reloadData()
    }
}

extension DateTodoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        taskArray.count
        switch isComplete{
        case true: return completeArray.count
        case false: return taskArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InnerCell", for: indexPath) as! InnerCollectionViewCell
        let rgbRed = taskArray[indexPath.row]["redcolor"] as! CGFloat
        let rgbBlue = taskArray[indexPath.row]["bluecolor"] as! CGFloat
        let rgbGreen = taskArray[indexPath.row]["greencolor"] as! CGFloat
        let alpha = taskArray[indexPath.row]["alpha"] as! CGFloat
        
        cell.backgroundColor = UIColor(red: rgbRed, green: rgbGreen, blue: rgbBlue, alpha: alpha)
        cell.todoLabel.text = taskArray[indexPath.row]["content"] as? String
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 20, bottom: 10, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let actionProvider: ([UIMenuElement]) -> UIMenu? = { _ in
            let complete = UIAction(title: "Complete", image: nil, identifier: UIAction.Identifier(rawValue: "complete")) { _ in
                let selectedDocID = self.taskArray[indexPath.row]["documentID"] as! String
                self.taskArray[indexPath.row]["isComplete"] = true
                guard let user = self.user else { return }
                self.db.collection("users")
                    .document(user.uid)
                    .collection("tasks")
                    .document(selectedDocID)
                    .setData(self.taskArray[indexPath.row], merge: true)
                
                self.completeArray.append(self.taskArray[indexPath.row])
                self.taskArray.remove(at: indexPath.row)
            }
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: UIAction.Identifier(rawValue: "delete")) {[self] _ in
                var selectedDocID = String()
                switch isComplete{
                case true:
                    selectedDocID = self.completeArray[indexPath.row]["documentID"] as! String
                case false:
                    selectedDocID = self.taskArray[indexPath.row]["documentID"] as! String
                }
                guard let user = self.user else { return }
                self.db.collection("users")
                    .document(user.uid)
                    .collection("tasks")
                    .document(selectedDocID)
                    .delete(){ err in
                        if let err = err {
                        } else {
                            switch self.isComplete{
                            case true: self.completeArray.remove(at: indexPath.row)
                            case false: self.taskArray.remove(at: indexPath.row)
                            }
//                            self.taskArray.remove(at: indexPath.row)
                            self.collectionView.reloadData()
                            if self.taskArray.isEmpty || self.completeArray.isEmpty {
                                let preNC = self.navigationController!
                                let preVC = preNC.viewControllers[preNC.viewControllers.count - 2] as! MyTodoViewController
                                
                                preVC.timeArray.removeAll(where: {$0 == self.date})
                                preVC.OuterCollectionView.reloadData()
                            }
                        }
                    }
            }
            delete.attributes = [.destructive]
            return UIMenu(title: "menu", image: nil, identifier: nil, children: [complete, delete])
        }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: actionProvider)
    }
}
