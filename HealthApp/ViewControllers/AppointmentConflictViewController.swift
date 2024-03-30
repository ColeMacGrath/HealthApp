//
//  AppointmentConflictViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-03-29.
//

import UIKit

class AppointmentConflictViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: CacheImageView!
    @IBOutlet weak var personTitleLabel: UILabel!
    @IBOutlet weak var personSubtitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var appointment: Appointment!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profilePictureImageView.loadImageFrom(url: self.appointment.doctor.profilePicture)
        self.personTitleLabel.text = self.appointment.doctor.fullName
        self.personSubtitleLabel.text = self.appointment.doctor.specialization
        self.dateLabel.text = self.appointment.date.shortDateWithYear
        self.timeLabel.text = self.appointment.date.twelveHoursFormmatedHour
        
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func goBackButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func cancelAppointmentButtonPressed(_ sender: UIButton) {
        guard let url = URL(string: RequestManager.shared.baseURL + "\(self.appointment.id)/" + EndPoint.appointments.rawValue) else {
            self.showFloatingAlert(text: "Error deleting appointment", alertType: .error)
            return
        }
        Task {
            guard await RequestManager.shared.request(url: url, method: .delete).httpStatusCode == .empty else {
                self.showFloatingAlert(text: "Error deleting appointment", alertType: .error)
                return
            }
            
            self.showFloatingAlert(text: "Appointment Deleted", alertType: .success)
            self.dismiss(animated: true)
            
        }
    }
    
}
