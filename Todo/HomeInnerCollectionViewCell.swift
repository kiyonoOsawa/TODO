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
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
//        HomeInnerCollectionViewCell.collectionViewLayout = layout
        label.lineBreakMode = .byWordWrapping
        self.layer.cornerRadius = 5.28
        self.uiImage()
    }
    
    func uiImage() {
        todoLabel.layer.cornerRadius = 5.28
    }
}
