//
//  DateRecipeTableViewCell.swift
//  CookFacilitator
//
//  Created by Moisés Córdova on 6/17/19.
//  Copyright © 2019 Moisés Córdova. All rights reserved.
//

import UIKit

class AppointmentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var appointmentTitleLabel: UILabel!
    @IBOutlet weak var doctorNameLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
