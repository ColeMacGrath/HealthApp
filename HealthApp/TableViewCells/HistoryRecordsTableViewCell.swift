//
//  HistoryRecordsTableViewCell.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 29/12/23.
//

import UIKit

class HistoryRecordsTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customizeCell(date: String, value: String, time: String) {
        self.dateLabel.text = date
        self.valueLabel.text = value
        self.timeLabel.text = time
    }

}
