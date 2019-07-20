//
//  SaveAppointmentViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 7/7/19.
//  Copyright © 2019 Moisés Córdova. All rights reserved.
//

import UIKit
import RealmSwift

class SaveAppointmentViewController: UIViewController {

    var textView: UITextView!
    var doctor: Doctor!
    var patient: Patient!
    var date: Date!
    var hourPicker: UIDatePicker!
    var realm = try? Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let parent = self.parent as? CreateAppointmentViewController {
            self.doctor = parent.selectedDoctor
            self.patient = parent.patient
            self.date = parent.selectedDate
        }
    }

}

extension SaveAppointmentViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! DoctorProfileTableViewCell
            cell.nameLabel.text = "\(doctor.firstName) \(doctor.lastName)"
            cell.specialityLabel.text = doctor.specialty
            cell.profileImageView.image = doctor.profilePicture ?? UIImage(named: "profile-placeholder")
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath)
            cell.textLabel?.text = "Notes From Doctor"
            cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 22.0)
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.tintColor = #colorLiteral(red: 0.2691037357, green: 0.3240052462, blue: 0.5610219836, alpha: 1)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteTableViewCell
            self.textView = cell.noteTextView
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath)
            cell.textLabel?.text = "Select the hour"
            cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 22.0)
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.tintColor = #colorLiteral(red: 0.2691037357, green: 0.3240052462, blue: 0.5610219836, alpha: 1)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PickerCell", for: indexPath) as! PickerTableViewCell
            self.hourPicker = cell.datePicker
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCardTableViewCell
            cell.titleLabel.text = "Save"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 250.0
        case 1, 3:
            return 50.0
        case 2:
            return UITableView.automaticDimension
        case 4:
            return 200.0
        default:
            return 100.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 5 {
            let pickerDate = hourPicker.date
            let components = Calendar.current.dateComponents([.hour, .minute], from: pickerDate)
            let hour = components.hour!
            let minute = components.minute!
            
            let finalDate = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date())!
            let appointment = Appointment(startDate: finalDate, endDate: finalDate, doctorUid: doctor.uid, patientUid: patient.uid, notes: textView.text)
            
            if self.realm?.object(ofType: Appointment.self, forPrimaryKey: appointment.id) == nil {
                do {
                    try realm?.write {
                        patient.appointments.append(appointment)
                    }
                } catch {
                    print("Error saving appointment: \(error.localizedDescription)")
                }
                _ = appointment.createInCalendar(doctor: self.doctor)
                NotificationCenter.default.post(name: NSNotification.Name("UpdateAppointmentsTable"), object: nil)
                if let parentViewController = self.parent as? CreateAppointmentViewController {
                    parentViewController.createdAppointment = appointment
                }
            } else {
                let alert = UIAlertController(title: "Appointmetn created", message: "you've got another appointment at same hour with same doctor", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true)
            }
        }
    }
}
