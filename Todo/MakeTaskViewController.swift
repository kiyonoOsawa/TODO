//
//  MakeTaskViewController.swift
//  Todo
//
//  Created by 大澤清乃 on 2022/01/16.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class MakeTaskViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var color1: UIButton!
    @IBOutlet weak var color2: UIButton!
    @IBOutlet weak var color3: UIButton!
    @IBOutlet weak var color4: UIButton!
    @IBOutlet weak var color5: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func savecontentButton() {
        
    }
    
}
