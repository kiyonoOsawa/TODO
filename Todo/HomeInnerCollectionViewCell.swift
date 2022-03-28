//
//  HomeInnerCollectionViewCell.swift
//  Todo
//
//  Created by 大澤清乃 on 2022/03/28.
//

import UIKit

class HomeInnerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var todoLabel: UILabel!
    
    let label = UILabel(frame: .zero)

    override func awakeFromNib() {
        super.awakeFromNib()
        label.lineBreakMode = .byWordWrapping
        self.layer.cornerRadius = 4
        self.uiImage()
    }
    
    func uiImage() {
        todoLabel.layer.cornerRadius = 4
    }
}
