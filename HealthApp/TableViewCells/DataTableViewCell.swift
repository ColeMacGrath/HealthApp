//
//  DataTableViewCell.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 29/12/23.
//

import UIKit

class DataTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customizeCell(title: String, value: String, image: UIImage) {
        self.titleLabel.text = title
        self.valueLabel.text = value
        self.customImageView.image = image
    }

}
