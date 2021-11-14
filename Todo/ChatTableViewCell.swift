//
//  ChatTableViewCell.swift
//  Todo
//
//  Created by 大澤清乃 on 2021/11/14.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var chatText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        chatText.layer.cornerRadius = 12
        chatText.layer.shadowOpacity = 0.25
        chatText.layer.shadowColor = UIColor.black.cgColor
        chatText.layer.shadowOffset = CGSize(width: 2, height: 3)
        chatText.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
