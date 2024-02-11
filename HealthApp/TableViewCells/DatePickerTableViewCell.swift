//
//  DatePickerTableViewCell.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 29/12/23.
//

import UIKit

class DatePickerTableViewCell: UITableViewCell {
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateDate() {
        self.monthLabel.text = "\(self.datePicker.date.abbreviatedMonth) \(self.datePicker.date.day)"
        self.yearLabel.text = "\(self.datePicker.date.year)"
    }

}
