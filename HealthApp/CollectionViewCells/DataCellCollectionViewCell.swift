//
//  DataCellCollectionViewCell.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 29/12/23.
//

import UIKit

class DataCellCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        contentView.layer.cornerRadius = 10.0
    }
    
    func customizeCell(image: UIImage, title: String, value: String, color: UIColor) {
        self.imageView.image = image
        self.titleLabel.text = title
        self.valueLabel.text = value
        self.contentView.backgroundColor = color
    }
    
}
