//
//  CollectionViewCell.swift
//  Todo
//
//  Created by 大澤清乃 on 2021/11/14.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        groupImage.layer.cornerRadius = 28
        groupImage.layer.borderWidth = 1
        groupImage.layer.borderColor = CGColor(red: 160/255, green: 118/255, blue: 236/255, alpha: 1.0)
        groupImage.layer.backgroundColor = CGColor(red: 239/255, green: 232/255, blue: 251/255, alpha: 1.0)
        groupImage.layer.masksToBounds = true
    }

}
