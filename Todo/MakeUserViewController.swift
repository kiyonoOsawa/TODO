//
//  MakeUserViewController.swift
//  Todo
//
//  Created by 大澤清乃 on 2021/12/12.
//

import UIKit

class MakeUserViewController: UIViewController {
    
    @IBOutlet weak var userProfileButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    
//    let storageRef = Storage.storage().reference

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func tappedProfileButton(_ sender: Any) {
        // 画像を選択
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        imagePickerViewController.allowsEditing = true
        
        self.present(imagePickerViewController, animated: true, completion: nil)
    }
    
    func transition(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabview = storyboard.instantiateViewController(withIdentifier: "tab") as! UITabBarController
        tabview.modalPresentationStyle = .fullScreen
        tabview.selectedIndex = 0
        self.present(tabview, animated: true, completion: nil)
    }
}

extension MakeUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
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
