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
    }
}
