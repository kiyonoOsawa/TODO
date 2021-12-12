//
//  SignInViewController.swift
//  Todo
//
//  Created by 大澤清乃 on 2021/12/12.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageUI

class SignInViewController: UIViewController {
    
    let auth = Auth.auth()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func tappedLoginButton(_ sender: Any) {
        //        signInUser(
    }
    
    func signInUser(emailText: String, passwordText: String) {
        auth.signIn(withEmail: emailText, password: passwordText) { AuthDataResult, Error in
            if let err = Error{
                print("error: \(err)")
            }
            self.transition()
        }
    }
    func transition(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabView = storyboard.instantiateViewController(withIdentifier: "tab") as! UITabBarController
        tabView.selectedIndex = 0
        tabView.modalPresentationStyle = .fullScreen
        self.present(tabView, animated: true, completion: nil)
    }
    
    
}
