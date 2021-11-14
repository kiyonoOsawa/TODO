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
        
        groupImage.layer.cornerRadius = 38
        groupImage.layer.borderWidth = 1
        groupImage.layer.backgroundColor = UIColor.blue.cgColor
        groupImage.layer.masksToBounds = true
    }

}
