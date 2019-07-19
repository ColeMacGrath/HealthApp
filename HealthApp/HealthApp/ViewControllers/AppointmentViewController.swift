//
//  AppointmentViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 7/6/19.
//  Copyright © 2019 Moisés Córdova. All rights reserved.
//

import UIKit

class AppointmentViewController: UIViewController {
    
    var appointment: Appointment!
    var doctor: Doctor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        if appointment == nil && doctor == nil {
            if let parent = self.parent as? CreateAppointmentViewController {
                self.doctor = parent.selectedDoctor
                self.appointment = parent.createdAppointment
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

extension AppointmentViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CloseCell", for: indexPath) as! CloseTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorInfoCell", for: indexPath) as! AppointmentInformationTableViewCell
            cell.doctorNameLabel.text = "\(doctor.firstName) \(doctor.lastName)"
            cell.specialityLabel.text = doctor.specialty
            cell.dateLabel.text = appointment.startDate.formattedDate
            cell.hourLabel.text = appointment.startDate.hourAndMinutes
            cell.profileImageView.image = doctor.profilePicture ?? UIImage(named: "profile-placeholder")
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath)
            cell.textLabel?.text = "Notes From Doctor"
            cell.textLabel?.tintColor = #colorLiteral(red: 0.2691037357, green: 0.3240052462, blue: 0.5610219836, alpha: 1)
            cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 22.0)
            cell.textLabel?.textAlignment = .left
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteTableViewCell
            cell.noteTextView.text = "\(appointment.notes ?? "")"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0.0
        switch indexPath.row {
        case 0:
            height = 90.0
        case 1:
            height = 150.0
        case 2:
            height = 50.0
        default:
            height = UITableView.automaticDimension
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if let navigationController = self.navigationController {
                navigationController.popViewController(animated: true)
                return
            }
            
            dismiss(animated: true, completion: nil)
        }
    }
    
}
