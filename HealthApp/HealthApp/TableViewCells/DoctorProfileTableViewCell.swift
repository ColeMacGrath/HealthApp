//
//  DoctorProfileTableViewCell.swift
//  HealthApp
//
//  Created by Moisés Córdova on 10/06/20.
//  Copyright © 2020 Moisés Córdova. All rights reserved.
//

import UIKit

class DoctorProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ocupationLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
