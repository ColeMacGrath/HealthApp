//
//  DoctorCollectionViewCell.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 28/12/23.
//

import UIKit

class DoctorCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profileImageView: CacheImageView!
    @IBOutlet weak var specializationLabel: UILabel!
    @IBOutlet weak var clockIcon: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 8.0
        guard let profileImageView else { return }
        profileImageView.layer.cornerRadius = 8.0
    }
    
    func cutomizeCell(doctor: Doctor) {
        self.profileImageView.loadImageFrom(url: doctor.profilePicture)
        self.specializationLabel.text = doctor.specialization
        self.nameLabel.text = doctor.firstName
    }
}
