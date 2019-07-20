//
//  ContactTableViewCell.swift
//  HealthApp
//
//  Created by Moisés Córdova on 7/6/19.
//  Copyright © 2019 Moisés Córdova. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specialistButton: UIButton!
    var allowsSelection = false
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.setRounded()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if allowsSelection {
            self.accessoryType = selected ? .checkmark : .none
        }
    }

}
