//
//  InnerCollectionViewCell.swift
//  Todo
//
//  Created by 大澤清乃 on 2022/01/30.
//

import UIKit

class InnerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var todoLabel: UILabel!
    
    let label = UILabel(frame: .zero)

    override func awakeFromNib() {
        super.awakeFromNib()
        label.lineBreakMode = .byWordWrapping
        self.layer.cornerRadius = 5
        self.uiImage()
    }
    
    func uiImage() {
        todoLabel.layer.cornerRadius = 5
    }

}
