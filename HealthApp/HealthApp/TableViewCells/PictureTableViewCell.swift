//
//  PictureTableViewCell.swift
//  HealthApp
//
//  Created by Moisés on 04/07/20.
//  Copyright © 2020 Moisés Córdova. All rights reserved.
//

import UIKit

class PictureTableViewCell: UITableViewCell {

    @IBOutlet weak var cardIImage: CardImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
