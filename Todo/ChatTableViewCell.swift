//
//  ChatTableViewCell.swift
//  Todo
//
//  Created by 大澤清乃 on 2021/11/14.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var classmateTextVIew: UITextView!
    @IBOutlet weak var classmateImageView: UIImageView!
    @IBOutlet weak var textViewWidthConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        updateUI()
    }
    
    func updateUI() {
        classmateImageView.layer.cornerRadius = 20
        classmateImageView.layer.borderColor = UIColor.lightGray.cgColor
        classmateImageView.layer.borderWidth = 1
        classmateImageView.layer.masksToBounds = true
        classmateImageView.layer.backgroundColor = UIColor(red: 0/255, green: 199/255, blue: 190/255, alpha: 1.0).cgColor
        
        classmateTextVIew.layer.cornerRadius = 12
        classmateTextVIew.layer.shadowOpacity = 0.25
        classmateTextVIew.layer.shadowColor = UIColor.black.cgColor
        classmateTextVIew.layer.shadowOffset = CGSize(width: 2, height: 3)
        classmateTextVIew.layer.masksToBounds = false
        //textviewの編集可否
        classmateTextVIew.isEditable = false
        //textviewの選択の可否
        classmateTextVIew.isSelectable = false
        //textviewの長さに応じてセルの高さが決まるように
        classmateTextVIew.isScrollEnabled = false
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
