//
//  ScheduleCellTableViewCell.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-02-14.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var startTitle: UILabel!
    @IBOutlet weak var startHourLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var endHourLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customizeCell(days: String, startHour: String, endHour: String) {
        self.daysLabel.text = days
        self.startHourLabel.text = startHour
        self.endHourLabel.text = endHour
    }

}
