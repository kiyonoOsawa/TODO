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
    @IBOutlet weak var menuButton: UIButton!
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var viewWidth: CGFloat = 0.0
    var timeArray = [String]()
    var addresses: [[String : Any]] = []
    var completeArray: [[String : Any]] = []
    var todoArray: [[String : Any]] = []
    var date = String()
    var startingFrame: CGRect!
    var endingFrame: CGRect!
    var taskIsNull: Bool!
    var isComplete: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.design()
        viewWidth = view.frame.width
        OuterCollectionView.delegate = self
        OuterCollectionView.dataSource = self
        OuterCollectionView.register(UINib(nibName: "OuterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OuterCell")
        OuterCollectionView.allowsSelection = true
        OuterCollectionView.isUserInteractionEnabled = true
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        taskIsNull = false
        print("アッピアー")
        presentingViewController?.beginAppearanceTransition(false, animated: animated)
        super.viewWillAppear(animated)
        self.OuterCollectionView.reloadData()
        
        guard let user = user else { return }
        
        db.collection("users")
            .document(user.uid)
            .collection("tasks")
            .order(by: "time", descending: false)
            .addSnapshotListener{QuerySnapshot, Error in
                guard let querySnapshot = QuerySnapshot else {return}
                
                self.addresses.removeAll()
                self.completeArray.removeAll()
                self.todoArray.removeAll()
                
                if querySnapshot.documents.count == Optional(0) {
                    self.dayTaskIsNull()
                    self.taskIsNull = true
                    return
                }
                
                for doc in querySnapshot.documents{
                    let timeStamp = doc.data()["time"] as! Timestamp
                    let day = doc.data()["day"] as! String
                    let content = doc.data()["content"] as! String
                    let rgbRed = doc.data()["redcolor"] as! CGFloat
                    let rgbGreen = doc.data()["greencolor"] as! CGFloat
                    let rgbBlue = doc.data()["bluecolor"] as! CGFloat
                    let alpha = doc.data()["alpha"] as! CGFloat
                    let isComplete = doc.data()["isComplete"] as! Bool
                    
                    let time: Date = timeStamp.dateValue()
                    
                    self.timeArray.append(day)
                    let orderedSet: NSOrderedSet = NSOrderedSet(array: self.timeArray)
                    self.timeArray = orderedSet.array as! [String]
                    
                    self.addresses.append(
                        ["time": time,
                         "day": day,
                         "content": content,
                         "redcolor": rgbRed,
                         "greencolor": rgbGreen,
                         "bluecolor": rgbBlue,
                         "alpha": alpha,
                         "documentID": doc.documentID,
                         "isComplete": isComplete
                        ]
                    )
                    switch isComplete {
                    case false:
                        self.navigationItem.title = "未完了"
                        self.completeArray.append(
                            ["day": day,
                             "time": time,
                             "content": content,
                             "red": rgbRed,
                             "blue": rgbBlue,
                             "green": rgbGreen,
                             "alpha": alpha,
                             "documentID": doc.documentID,
                             "isComplete": isComplete]
                        )
//                        self.navigationItem.title = "未完了"
                        self.configureTimeArray()
                        
                    case true:
//                        self.navigationItem.title = "完了済"
                        self.todoArray.append(
                            ["day": day,
                             "time": time,
                             "content": content,
                             "red": rgbRed,
                             "blue": rgbBlue,
                             "green": rgbGreen,
                             "alpha": alpha,
                             "documentID": doc.documentID,
                             "isComplete": isComplete
                            ]
                        )
//                        self.navigationItem.title = "完了済"
                        self.configureTimeArray()
                    }
                    print("データ取り出し\(doc)")
                }
                self.OuterCollectionView.reloadData()
            }
    }
    
    func configureTimeArray() {
        timeArray.removeAll()
        switch isComplete{
        case false:
            for content in todoArray{
                let contentTime = content["day"] as! String
                timeArray.append(contentTime)
                let orderedSet: NSOrderedSet = NSOrderedSet(array: self.timeArray)
                self.timeArray = orderedSet.array as! [String]
            }
        case true:
            for content in completeArray{
                let contentTime = content["day"] as! String
                timeArray.append(contentTime)
                let orderedSet: NSOrderedSet = NSOrderedSet(array: self.timeArray)
                self.timeArray = orderedSet.array as! [String]
            }
        }
    }
    
    @IBAction func tappedAddButton() {
        self.performSegue(withIdentifier: "toMakeTask", sender: nil)
    }
    
    @IBAction func tappedMenuButton() {
        self.performSegue(withIdentifier: "toMenu", sender: nil)
    }
    
    func dayTaskIsNull() {
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy年MM月dd日"
        print("わかりやすい文字列",dateFormatter.string(from: now))
        let day = dateFormatter.string(from: now)
        let content = ""
        let rgbRed = CGFloat(0.0)
        let rgbGreen = CGFloat(0.0)
        let rgbBlue = CGFloat(0.0)
        let alpha = CGFloat(0.0)
        let isComplete = false
        
        self.timeArray.append(dateFormatter.string(from: now))
        let orderedSet: NSOrderedSet = NSOrderedSet(array: self.timeArray)
        self.timeArray = orderedSet.array as! [String]
        
        self.addresses.append(
            ["time": time,
             "day": day,
             "content": content,
             "redcolor": rgbRed,
             "greencolor": rgbGreen,
             "bluecolor": rgbBlue,
             "alpha": alpha,
             "documentID": nil,
             "isComplete": isComplete
            ]
        )
        self.OuterCollectionView.reloadData()
        taskIsNull = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDateTodo"{
            let vc = segue.destination as! DateTodoViewController
            vc.addresses = self.addresses
            vc.date = self.date
            vc.isComplete = self.isComplete
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) && self.addButton.isHidden {
            self.addButton.isHidden = false
            self.addButton.frame = startingFrame
            UIView.animate(withDuration: 1.0) {
                self.addButton.frame = self.endingFrame
            }
        }
    }
    
    func configureSizes() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        startingFrame = CGRect(x: 0, y: screenHeight+100, width: screenWidth, height: 100)
        endingFrame = CGRect(x: 0, y: screenHeight-100, width: screenWidth, height: 100)
    }
}

extension MyTodoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,OuterCollectionViewCellDelegate {
    
    func tappedCell(date: String) {
        self.date = date
        self.performSegue(withIdentifier: "toDailyTasks", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("---画面B cellForRowAt:\(#function)")
        
        let cell = OuterCollectionView.dequeueReusableCell(withReuseIdentifier: "OuterCell", for: indexPath) as! OuterCollectionViewCell
        cell.layer.cornerRadius = 12
        cell.layer.shadowOpacity = 0.25
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.masksToBounds = false
        
        cell.dateLabel.text = timeArray[indexPath.row]
        if taskIsNull == true {
            cell.taskCountLabel.text = "0"
            print("こことおった")
        } else {
            let filList = addresses.filter{$0["day"] as! String == timeArray[indexPath.row]}
            cell.taskCountLabel.text = String(filList.count)
        }
        switch isComplete {
        case false:
            cell.configureCell(contentArray: todoArray, date: timeArray[indexPath.row])
            self.OuterCollectionView.reloadData()
        case true:
            cell.configureCell(contentArray: completeArray, date: timeArray[indexPath.row])
            self.OuterCollectionView.reloadData()
        }
        //        cell.configureCell(contentArray: addresses, date: timeArray[indexPath.row])
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,  section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func design() {
        addButton.imageView?.contentMode = .scaleAspectFill
        addButton.contentHorizontalAlignment = .fill
        addButton.contentVerticalAlignment = .fill
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}
