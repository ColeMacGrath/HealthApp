//
//  TextFieldTableViewCell.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 28/12/23.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
