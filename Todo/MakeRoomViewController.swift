//
//  MakeRoomViewController.swift
//  Todo
//
//  Created by 大澤清乃 on 2021/11/14.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseStorageUI

class MakeRoomViewController: UIViewController {
    
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var roomNumberTextField: UITextField!
    
    let db = Firebase.Firestore.firestore()
    let storageRef = Storage.storage().reference(forURL: "gs://todo-c7ff6.appspot.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileButton.layer.cornerRadius = 50
        profileButton.layer.borderWidth = 1
        profileButton.layer.borderColor = UIColor.blue.cgColor
        
    }
    
    @IBAction func tappedProfileButton(_ sender: Any) {
        // 画像を選択
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        imagePickerViewController.allowsEditing = true
        
        self.present(imagePickerViewController, animated: true, completion: nil)
    }
    
    @IBAction func tappedAddButton(_ sender: Any) {
        // データを追加
        let addData = [
            "roomName": roomNameTextField.text!,
            "roomNumber": roomNumberTextField.text!]
        
        db.collection("groups")
            .addDocument(data: addData){ err in
                if let error = err {
                    print("保存に失敗しました:\(error)")
                }
                let reference = self.storageRef.child("groupProfile").child("\(self.roomNameTextField.text!).jpg")
                guard let image = self.profileButton.imageView?.image else{
                    return
                }
                guard let uploadImage = image.jpegData(compressionQuality: 0.2) else{
                    return
                }
                reference.putData(uploadImage, metadata: nil){ (metaData, err) in
                    if let error = err {
                    }
                }
            }
        self.dismiss(animated: true, completion: nil)
    }
}

extension MakeRoomViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // サイズなどを変えた際に受け取るイメージ
        if let image = info[.editedImage] as? UIImage{
            profileButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
            // 大きさが何も変わっていない
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        profileButton.setTitle("", for: .normal)
        profileButton.imageView?.contentMode = .scaleAspectFill
        profileButton.contentHorizontalAlignment = .fill
        profileButton.contentVerticalAlignment = .fill
        profileButton.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
}
