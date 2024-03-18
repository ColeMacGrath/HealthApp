//
//  ProfileCollectionViewCell.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 28/12/23.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profileImageView: CacheImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var biologicalSexLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        guard let profileImageView else { return }
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
    }
    
    func customizeCell(image: UIImage, name: String, biologicalSex: String) {
        self.profileImageView.image = image
        self.nameLabel.text = name
        self.biologicalSexLabel.text = biologicalSex
    }
}
