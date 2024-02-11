//
//  AppointmentTableViewCell.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 28/12/23.
//

import UIKit

class AppointmentTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var customImageView: CacheImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        guard let customImageView else { return }
        customImageView.setCircularImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customizeCell(appointment: Appointment) {
        self.customImageView.loadImageFrom(url: appointment.doctor.profilePicture)
        self.nameLabel.text = appointment.doctor.fullName
        self.dateLabel.text = appointment.date.longDate
    }

}
