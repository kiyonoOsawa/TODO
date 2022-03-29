//
//  MakeTaskViewController.swift
//  Todo
//
//  Created by 大澤清乃 on 2022/01/16.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class MakeTaskViewController: UIViewController, UIColorPickerViewControllerDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var color: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var backButton: UIButton!
    
    let alert: UIAlertController = UIAlertController(title: "保存", message: "完了しました", preferredStyle: .alert)
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    //    let userDefaults = UserDefaults.standard
    var timeArray = [String]()
    var didselectColor = UIColor()
    var rgbRed = CGFloat()
    var rgbGreen = CGFloat()
    var rgbBlue = CGFloat()
    var alpha = CGFloat()
    var isComplete: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiImage()
    }
    
    func updateFirestore() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        let time = formatter.string(from: datePicker.date)
        timeArray.append(time)
        let orderedSet: NSOrderedSet = NSOrderedSet(array: timeArray)
        timeArray = orderedSet.array as! [String]
        //        userDefaults.set(timeArray, forKey: "time")
        
        datePicker
        
        let user = user
        guard let user = user else {return}
        
        let addData:[String: Any] = [
            "time":Timestamp(date: datePicker.date),
            "day": time,
            "content":textView.text!,
            "redcolor": rgbRed,
            "greencolor": rgbGreen,
            "bluecolor": rgbBlue,
            "alpha":alpha,
            "isComplete": isComplete
        ]
        db.collection("users")
            .document(user.uid)
            .collection("tasks")
            .addDocument(data: addData)
    }
    
    @IBAction func savecontentButton() {
        updateFirestore()
        //        self.navigationController?.popViewController(animated: true)
        print("前に戻る")
        self.dismiss(animated: true, completion: nil)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tappedColor() {
        showColorPicker()
    }
    
    func uiImage() {
        
        textView.layer.cornerRadius = 12
        textView.layer.shadowOpacity = 0.2
        textView.layer.shadowColor = UIColor.black.cgColor
        textView.layer.shadowOffset = CGSize(width: 0, height: 0)
        textView.layer.masksToBounds = false
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        textView.sizeToFit()
        color.layer.cornerRadius = 20
        color.layer.borderWidth = 1
        color.layer.shadowColor = UIColor.black.cgColor
        color.setTitle("", for: .normal)
    }
    
    
    func showColorPicker() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.selectedColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        colorPicker.delegate = self
        self.present(colorPicker, animated: true, completion: nil)
    }

    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        print("選択した色:\(viewController.selectedColor)")
                didselectColor = viewController.selectedColor
    }

    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        rgbRed = viewController.selectedColor.redColor!
        rgbGreen = viewController.selectedColor.greenColor!
        rgbBlue = viewController.selectedColor.blueColor!
        alpha = viewController.selectedColor.alpha
        didselectColor = viewController.selectedColor
        color.backgroundColor = didselectColor
    }
    
    @IBAction func tappedBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension UIColor {
    var redColor: CGFloat? {
        return self.cgColor.components?[0]
    }
    
    var greenColor: CGFloat? {
        return self.cgColor.components?[1]
    }
    
    var blueColor: CGFloat? {
        return self.cgColor.components?[2]
    }
    
    var alpha: CGFloat {
        return self.cgColor.alpha
    }
}

