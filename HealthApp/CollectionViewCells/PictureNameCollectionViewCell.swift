//
//  PictureNameCollectionViewCell.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-02-12.
//

import UIKit

class PictureNameCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func customizeCell(picture: UIImage, name: String) {
        self.pictureImageView.image = picture
        self.nameLabel.text = name
        self.pictureImageView.setCircularImage()
        self.pictureImageView.layer.borderWidth = 4
        self.pictureImageView.layer.borderColor = UIColor.white.cgColor
    }
}
