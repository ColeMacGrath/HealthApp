//
//  BookAppointmentViewController.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 29/12/23.
//

import UIKit

class BookAppointmentViewController: UIViewController {
    
    var doctor: Doctor!
    var datePicker: UIDatePicker?
    var notesTextView: UITextView?
    var conflictAppointment: Appointment?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setMinimalBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Constants.Segues.showAppointmentConflictVC,
              let conflictAppointment,
              let destination = segue.destination as? AppointmentConflictViewController else { return }
        destination.appointment = conflictAppointment
    }
    
    private func bookAppointment() async {
        guard let date = datePicker?.date,
        let patientId = SessionManager.shared.getPatientId() else { return }
        var body: Dictionary<String, Any> = [
            "doctorId": self.doctor.id,
            "date": date.ISO8601WithwithFractionalSeconds,
            "userId": patientId
        ]
        if let notes = notesTextView?.text {
            body["notes"] = notes
        }
        
        let response = await RequestManager.shared.request(endPoint: .bookApointment, method: .post, body: body)
        if response.httpStatusCode == .conflict,
           let rawData = response.rawData {
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .customISO8601
                let appointment = try decoder.decode(Appointment.self, from: rawData)
                self.conflictAppointment = appointment
                self.performSegue(withIdentifier: Constants.Segues.showAppointmentConflictVC, sender: nil)
            } catch {
                self.showFloatingAlert(text: "Unavailable schedule for \(self.doctor.firstName)", alertType: .error)
            }
            return
        }
        
        guard response.httpStatusCode == .created else {
            self.showFloatingAlert(text: "Couldn't create appointment", alertType: .error)
            return
        }
        
        self.showFloatingAlert(text: "Appointment created", alertType: .success)
        self.navigationController?.popToRootViewController(animated: true)
    }

}

extension BookAppointmentViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.imageCell, for: indexPath) as! ImageTableViewCell
                cell.separatorInset.removeSeparator()
                cell.customizeCell(url: self.doctor.profilePicture)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.basicCell, for: indexPath)
            cell.backgroundColor = .systemGroupedBackground
            cell.selectionStyle = .none
            cell.separatorInset.removeSeparator()
            var content = UIListContentConfiguration.cell()
            content.textProperties.alignment = .center
            content.secondaryTextProperties.alignment = .center
            content.textProperties.font = UIFont(name: "HelveticaNeue-Medium", size: 22.0) ?? UIFont()
            content.text = self.doctor.fullName
            content.secondaryTextProperties.font = UIFont(name: "HelveticaNeue", size: 18.0) ?? UIFont()
            content.secondaryTextProperties.color = .secondaryLabel
            content.secondaryText = self.doctor.specialization
            
            cell.contentConfiguration = content
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.inlineDatePicker, for: indexPath) as! InlineDatePickerTableViewCell
            if self.datePicker == nil {
                self.datePicker = cell.datePicker
            } else {
                cell.datePicker = self.datePicker
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.textViewCell, for: indexPath) as! TextViewTableViewCell
            if self.notesTextView == nil {
                self.notesTextView = cell.textView
            } else {
                cell.textView = self.notesTextView
            }
            cell.backgroundColor = .secondarySystemGroupedBackground
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.basicCell, for: indexPath)
            cell.backgroundColor = .systemRed
            cell.selectionStyle = .default
            var content = UIListContentConfiguration.cell()
            content.textProperties.alignment = .center
            content.textProperties.color = .white
            content.textProperties.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0) ?? UIFont()
            content.text = "Book Appointment"
            cell.contentConfiguration = content
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        Task {
            await self.bookAppointment()
        }
        
        
        /*self.showFloatingAlert(text: "Appointment Booked", alertType: .success)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.navigationController?.popViewController(animated: true)
        })*/
        
        tableView.deselectRow(at: indexPath, animated: true )
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Date and Time"
        case 2:
            return "Notes"
        default:
            return nil
        }
    }
}
