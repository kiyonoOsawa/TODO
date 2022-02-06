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
    
    @IBOutlet var textFieldImage: [UITextField]!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorImage()
    }
    
    @IBAction func tappedLoginButton(_ sender: Any) {
        signInUser(emailText: emailTextField.text!, passwordText: passwordTextField.text!)
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
    
    func colorImage() {
        
        let Purple = UIColor(named: "Purple")
        guard let Purple = Purple else { return }
        
        for textFieldImage in textFieldImage {
            textFieldImage.layer.cornerRadius = 24
            textFieldImage.backgroundColor = UIColor.white
            textFieldImage.layer.borderWidth = 1
            textFieldImage.layer.borderColor = Purple.cgColor
            textFieldImage.layer.shadowOpacity = 0.5
            textFieldImage.layer.shadowColor = UIColor.gray.cgColor
            textFieldImage.layer.shadowOffset = CGSize(width: 1, height: 1)
            textFieldImage.layer.masksToBounds = false
            let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
            leftPadding.backgroundColor = UIColor.clear
            textFieldImage.leftView = leftPadding
            textFieldImage.leftViewMode = .always
        }
        
        logInButton.layer.cornerRadius = 24
    }
    
}
