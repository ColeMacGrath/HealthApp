//
//  InlineDatePickerTableViewCell.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 29/12/23.
//

import UIKit

class InlineDatePickerTableViewCell: UITableViewCell {

    @IBOutlet weak var datePicker: UIDatePicker!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
