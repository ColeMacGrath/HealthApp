//
//  DualSelectionTableViewCell.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-02-14.
//

import UIKit

class DualSelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var availableButton: UIButton!
    @IBOutlet weak var unavailableButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
