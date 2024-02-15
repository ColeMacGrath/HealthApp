//
//  ProfileHorizontalTableViewCell.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-02-14.
//

import UIKit

class ProfileHorizontalTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImaeView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specilizationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImaeView.setCircularImage()
    }

    func customizeCell(picture: UIImage, name: String, specilization: String) {
        self.profileImaeView.image = picture
        self.nameLabel.text = name
        self.specilizationLabel.text = specilization
    }

}
