//
//  ProfileViewController.swift
//  Todo
//
//  Created by 大澤清乃 on 2022/02/27.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var emailTextView: UITextView!
    @IBOutlet weak var logOutButton: UIButton!
    
    let auth = Auth.auth()
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference(forURL: "gs://todo-c7ff6.appspot.com")
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemRed
        appearance.titleTextAttributes = [.foregroundColor: UIColor.lightText]
        navigationController?.navigationBar.prefersLargeTitles = true
        setUI()
        fetchData()
        imageViewDesign()
    }
    
    func setUI(){
        nameTextView.isEditable = false
        emailTextView.isEditable = false
//        profileImageButton.layer.masksToBounds = true
    }
    
    func fetchData(){
        guard let user = user else { return }
        db.collection("users")
            .document(user.uid)
            .getDocument{ DocumentSnapshot, Error in
                guard let data = DocumentSnapshot?.data() else { return }
                let userName = data["userName"] as! String
                self.nameTextView.text = userName
            }
        emailTextView.text = user.email
        let reference = self.storageRef.child("userProfile").child("\(user.uid).jpg")
        profileImageView.sd_setImage(with: reference)
    }
    
    func imageViewDesign(){
        profileImageView.layer.cornerRadius = 5
    }
    
    @IBAction func tappedLogOut() {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "firstView")
            nextVC?.modalPresentationStyle = .fullScreen
            self.present(nextVC!, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
