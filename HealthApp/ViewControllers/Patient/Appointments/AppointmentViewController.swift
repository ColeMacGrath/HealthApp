//
//  AppointmentViewController.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 29/12/23.
//

import UIKit

class AppointmentViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var appointment: Appointment!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.alwaysBounceVertical = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func deleteAppointmentButtonPressed(_ sender: UIButton) {
        guard let url = URL(string: RequestManager.shared.baseURL + "\(self.appointment.id)/" + EndPoint.appointment.rawValue) else {
            self.showFloatingAlert(text: "Error deleting appointment", alertType: .error)
            return
        }
        Task {
            guard await RequestManager.shared.request(url: url, method: .delete).httpStatusCode == .empty else {
                self.showFloatingAlert(text: "Error deleting appointment", alertType: .error)
                return
            }
            
            self.showFloatingAlert(text: "Appointment Deleted", alertType: .success)
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    
}


extension AppointmentViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let doctor = self.appointment.doctor
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.imageCell, for: indexPath) as! ImageTableViewCell
                cell.separatorInset.removeSeparator()
                cell.customizeCell(url: doctor.profilePicture)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.basicCell, for: indexPath)
            cell.backgroundColor = .clear
            cell.separatorInset.removeSeparator()
            
            var content = UIListContentConfiguration.cell()
            content.textProperties.alignment = .center
            content.secondaryTextProperties.alignment = .center
            content.textProperties.font = UIFont(name: "HelveticaNeue-Medium", size: 22.0) ?? UIFont()
            content.text = doctor.fullName
            content.secondaryTextProperties.font = UIFont(name: "HelveticaNeue", size: 18.0) ?? UIFont()
            content.secondaryTextProperties.color = .secondaryLabel
            content.secondaryText = doctor.specialization
            
            cell.contentConfiguration = content
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.dateTimeCell, for: indexPath) as! DateTimeTableViewCell
            cell.dateLabel.text = self.appointment.date.shortDateWithYear
            cell.timeLabel.text = self.appointment.date.twelveHoursFormmatedHour
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.basicCell, for: indexPath)
            cell.contentView.backgroundColor = .secondarySystemGroupedBackground
            var content = UIListContentConfiguration.cell()
            content.text = self.appointment.notes
            content.textProperties.color = .secondaryLabel
            cell.contentConfiguration = content
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Date and Time"
        } else if section == 2 {
            return "Notes"
        }
        return nil
    }
}
