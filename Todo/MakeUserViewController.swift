//
//  MakeUserViewController.swift
//  Todo
//
//  Created by 大澤清乃 on 2021/12/12.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class MakeUserViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var textFieldImage: [UITextField]!
    @IBOutlet weak var userProfileButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var toLogInButton: UIButton!
    @IBOutlet weak var error1: UILabel!
    @IBOutlet weak var error2: UILabel!
    @IBOutlet weak var error3: UILabel!
    
    let storageRef = Storage.storage().reference(forURL: "gs://todo-c7ff6.appspot.com")
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.error1.isHidden = true
        self.error2.isHidden = true
        self.error3.isHidden = true
        if user != nil {
            print(user)
            transition()
        } else {
        }
    }
    
    @IBAction func tappedProfileButton(_ sender: Any) {
        // 画像を選択
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        imagePickerViewController.allowsEditing = true
        
        self.present(imagePickerViewController, animated: true, completion: nil)
    }
    
    @IBAction func tappedSignUpButton(_ sender: Any) {
        if (emailTextField.text?.isEmpty == true) || (userNameTextField.text?.isEmpty == true) || (passWordTextField.text?.isEmpty == true) || (userProfileButton.imageView?.image == nil) {
            let alert = UIAlertController(title: "", message: "プロフィール画像,e-mail,名前,パスワードを全て入力してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            }
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
        
        if emailTextField.text != nil && passWordTextField.text != nil{
            createUser(emailText: emailTextField.text!, passwordText: passWordTextField.text!)
        }
    }
    
    @IBAction func toLoginButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toLogin", sender: nil)
    }
    
    func createUser(emailText: String, passwordText: String){
        Auth.auth().createUser(withEmail: emailText, password: passwordText) { FIRAuthDataResult, Error in
            if Error == nil {
            } else {
                if let errCode = AuthErrorCode(rawValue: Error!._code) {
                    switch errCode {
                    case .invalidEmail: self.error1.isHidden = false
                        // メールアドレスの形式が違います。
                    case .emailAlreadyInUse: self.error2.isHidden = false
                        // このメールアドレスはすでに使われています。
                    case .weakPassword: self.error3.isHidden = false
                        // パスワードは6文字以上で入力してください。
                    default: break
                    }
                }
            }
            guard let authResult = FIRAuthDataResult else {
                print("error: SignUp")
                print(Error.debugDescription)
                return
            }
            let reference = self.storageRef.child("userProfile").child("\(authResult.user.uid).jpg")
            guard let image = self.userProfileButton.imageView?.image else {
                return
            }
            guard let uploadImage = image.jpegData(compressionQuality: 0.2) else{
                return
            }
            reference.putData(uploadImage, metadata: nil){(metadate, err) in
                if let error = err{
                    print("error: \(error)")
                }
            }
            let addData = [
                "userName": self.userNameTextField.text!
            ]
            let db = Firebase.Firestore.firestore()
            db.collection("users")
                .document(authResult.user.uid)
                .setData(addData)
            self.transition()
        }
    }
    
    func transition(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabview = storyboard.instantiateViewController(withIdentifier: "tab") as! UITabBarController
        tabview.modalPresentationStyle = .fullScreen
        tabview.selectedIndex = 0
        self.present(tabview, animated: true, completion: nil)
    }
    
    func colorImage() {
        
        let Purple = UIColor(named: "Purple")
        guard let Purple = Purple else { return }
        
        //emailTextField
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
        signUpButton.layer.cornerRadius = 24
        
    }
}

extension MakeUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // サイズなどを変えた際に受け取るイメージ
        if let image = info[.editedImage] as? UIImage{
            userProfileButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
            // 大きさが何も変わっていない
        } else if let originalImage = info[.originalImage] as? UIImage {
            userProfileButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        userProfileButton.setTitle("", for: .normal)
        userProfileButton.imageView?.contentMode = .scaleAspectFill
        userProfileButton.contentHorizontalAlignment = .fill
        userProfileButton.contentVerticalAlignment = .fill
        userProfileButton.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
}
