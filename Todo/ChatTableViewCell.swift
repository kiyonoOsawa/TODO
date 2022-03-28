//
//  ChatTableViewCell.swift
//  Todo
//
//  Created by 大澤清乃 on 2021/11/14.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var classmateTextView: UITextView!
    @IBOutlet weak var classmateImageView: UIImageView!
    @IBOutlet weak var textViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var myTextViewConstraint: NSLayoutConstraint!
    
    var classmateMessageText: String? {
        didSet{
            guard let message = classmateMessageText else {return}
            //文字数からtextViewの幅を設定する
            let width = estimateTextViewSize(text: message).width + 20
            
            textViewWidthConstraint.constant = width
            //textViewの文字を取得
            classmateTextView.text = message
        }
    }
    
    var myMessageText: String? {
        didSet{
            guard let message = myMessageText else {return}
            myTextView.isHidden = false
            classmateTextView.isHidden = true
            let width = estimateTextViewSize(text: message).width + 20
            myTextViewConstraint.constant = width
            myTextView.text = message
        }
    }
    
    func estimateTextViewSize(text: String) -> CGRect{
        let size = CGSize(width: 200, height: 500)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        updateUI()
    }
    
    func updateUI() {
        classmateImageView.layer.cornerRadius = 20
        classmateImageView.layer.borderColor = UIColor.lightGray.cgColor
        classmateImageView.layer.masksToBounds = true
        
        classmateTextView.layer.cornerRadius = 12
        classmateTextView.layer.shadowOpacity = 0.25
        classmateTextView.layer.shadowColor = UIColor.black.cgColor
        classmateTextView.layer.shadowOffset = CGSize(width: 2, height: 3)
        classmateTextView.layer.masksToBounds = false
        //textviewの編集可否
        classmateTextView.isEditable = false
        //textviewの選択の可否
        classmateTextView.isSelectable = false
        //textviewの長さに応じてセルの高さが決まるように
        classmateTextView.isScrollEnabled = false
        myTextView.layer.cornerRadius = 12
        myTextView.isScrollEnabled = false
        myTextView.isEditable = false
        myTextView.isSelectable = false
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
