//
//  ColorTableViewCell.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 30/12/23.
//

import UIKit

class ColorTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.colorView.layer.cornerRadius = 8.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customizeCell(title: String, value: String, color: UIColor) {
        self.titleLabel.text = title
        self.valueLabel.text = value
        self.colorView.backgroundColor = color
    }

}
