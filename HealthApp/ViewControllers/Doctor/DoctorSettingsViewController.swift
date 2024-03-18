//
//  DoctorSettingsViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-02-14.
//

import UIKit

class DoctorSettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.alwaysBounceVertical = false
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
    }
}

extension DoctorSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 2 ? 3 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.profileHorizontalCell, for: indexPath) as! ProfileHorizontalTableViewCell
            cell.customizeCell(picture: .doctor, name: "Juan Gabriel Gomila Salas", specilization: "Oncologyst")
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.dualSelectionCell, for: indexPath) as! DualSelectionTableViewCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.scheduleCell, for: indexPath) as! ScheduleTableViewCell
            cell.customizeCell(days: "Mon, Tue, Fri", startHour: "10:00 AM", endHour: "08:00 PM")
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.basicCell, for: indexPath)
            var content = UIListContentConfiguration.cell()
            content.textProperties.font = UIFont(name: "HelveticaNeue", size: 18.0) ?? UIFont()
            if indexPath.section == 3 {
                cell.backgroundColor = .systemRed
                content.textProperties.color = .white
                content.textProperties.alignment = .center
                content.text = "Save"
            } else {
                cell.backgroundColor = .clear
                content.textProperties.color = .systemRed
                content.textProperties.alignment = .center
                content.text = "Log out"
            }
           
            cell.contentConfiguration = content
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            self.performSegue(withIdentifier: Constants.Segues.showSchedulesVC, sender: nil)
        } else if indexPath.section == 3 {
            self.navigationController?.popViewController(animated: true)
        } else if indexPath.section == 4 {
            SessionManager.shared.logOut()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Current Status"
        } else if section == 2 {
            return "Schedules"
        }
        
        return nil
    }
    
}
