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
        
        let layout = UICollectionViewFlowLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "InnerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "InnerCell")
        
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
        let rgbRed = taskArray[indexPath.row]["redcolor"] as! CGFloat
        let rgbBlue = taskArray[indexPath.row]["bluecolor"] as! CGFloat
        let rgbGreen = taskArray[indexPath.row]["greencolor"] as! CGFloat
        let alpha = taskArray[indexPath.row]["alpha"] as! CGFloat
        
        cell.backgroundColor = UIColor(red: rgbRed, green: rgbGreen, blue: rgbBlue, alpha: alpha)
        cell.todoLabel.text = taskArray[indexPath.row]["content"] as? String
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let actionProvider: ([UIMenuElement]) -> UIMenu? = { _ in
//            let share = UIAction(title: "delete", image: UIImage(systemName: "trash"), identifier: UIAction.Identifier(rawValue: "trash")) { _ in
//                self.deletItem(indexPath: indexPath)
//            }
////            return UIMenu(title: "Edit..", image: nil, identifier: nil, children: [delete, share])
//        }
//    }
//    func deletItem(indexPath: IndexPath){
//        let selectedDocID = addresses[indexPath.row]["documentID"] as! String
//        guard let user = user else{ return }
//        db.collection("users")
//            .document(user.uid)
//            .collection("tasks")
//            .document(selectedDocID)
//            .delete(){err in
//                if let err = err {
//                    print("Error removing document: \(err)")
//                } else {
//                    print("Document successfully removed!")
//                    self.taskArray.remove(at: indexPath.row)
//                    self.collectionView.reloadData()
//
//                    if self.taskArray.isEmpty {
//                        let preNC = self.navigationController!
//                        let preVC = preNC.viewControllers[preNC.viewControllers.count - 2] as! MyTodoViewController
//
//                        preVC.timeArray.removeAll(where: {$0 == self.date})
//                        preVC.OuterCollectionView.reloadData()
//                    }
//                }
//            }
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
                
//                self.completeArray.append(self.taskArray[indexPath.row])
//                self.taskArray.remove(at: indexPath.row)
            }
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: UIAction.Identifier(rawValue: "delete")) {[self] _ in
                let selectedDocID = self.taskArray[indexPath.row]["documentID"] as! String
                guard let user = self.user else { return }
                self.db.collection("users")
                    .document(user.uid)
                    .collection("tasks")
                    .document(selectedDocID)
                    .delete(){ err in
                        if let err = err {
                            
                        } else {
                            self.taskArray.remove(at: indexPath.row)
                            self.collectionView.reloadData()
                            
                            if self.taskArray.isEmpty {
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
