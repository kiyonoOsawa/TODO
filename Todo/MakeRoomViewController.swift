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
    
    @IBOutlet var textFieldImage: [UITextField]!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var roomNumberTextField: UITextField!
    @IBOutlet weak var overViewText: UITextField!
    
    let db = Firebase.Firestore.firestore()
    let storageRef = Storage.storage().reference(forURL: "gs://todo-c7ff6.appspot.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorImage()
    }
    
    @IBAction func tappedProfileButton(_ sender: Any) {
        // 画像を選択
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        imagePickerViewController.allowsEditing = true
        
        self.present(imagePickerViewController, animated: true, completion: nil)
    }
    
    @IBAction func tappedAddButton(_ sender: Any) {
        let emptyArray: [String] = []
        // データを追加
        let addData: [String : Any] = [
            "roomName": roomNameTextField.text!,
            "roomNumber": roomNumberTextField.text!,
            "registeredUser": emptyArray]
        
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
    
    func colorImage() {
        let Purple = UIColor(named: "Purple")
        guard let Purple = Purple else { return }
        
        //emailTextField
        for textFieldImage in textFieldImage {
            textFieldImage.layer.cornerRadius = 20
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
        addButton.layer.cornerRadius = 15
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
