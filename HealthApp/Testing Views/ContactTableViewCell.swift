//
//  ContactTableViewCell.swift
//  HealthApp
//
//  Created by Moisés Córdova on 7/4/19.
//  Copyright © 2019 Moisés Córdova. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specialiyButton: UIButton!
    @IBOutlet weak var disclousure: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImageView.setRounded()
        self.specialiyButton?.tintColor = UIColor.white
        self.specialiyButton.applyGradient(colours: [#colorLiteral(red: 0.9618651271, green: 0.6412356496, blue: 0.5046406984, alpha: 1), #colorLiteral(red: 0.9339064956, green: 0.3420327902, blue: 0.5013229251, alpha: 1)])
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
