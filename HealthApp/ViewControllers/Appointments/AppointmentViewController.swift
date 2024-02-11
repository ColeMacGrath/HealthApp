//
//  AppointmentViewController.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 29/12/23.
//

import UIKit

class AppointmentViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.alwaysBounceVertical = false
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
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.imageCell, for: indexPath) as! ImageTableViewCell
                cell.separatorInset.removeSeparator()
                cell.custommizeCell(image: UIImage(named: "doctor2") ?? UIImage())
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.basicCell, for: indexPath)
            cell.backgroundColor = .clear
            cell.separatorInset.removeSeparator()
            
            var content = UIListContentConfiguration.cell()
            content.textProperties.alignment = .center
            content.secondaryTextProperties.alignment = .center
            content.textProperties.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0) ?? UIFont()
            content.text = "Juan Gabriel Gomila Salas"
            content.secondaryTextProperties.font = UIFont(name: "HelveticaNeue", size: 18.0) ?? UIFont()
            content.secondaryTextProperties.color = .secondaryLabel
            content.secondaryText = "Cardilogyst"
            
            cell.contentConfiguration = content
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.dateTimeCell, for: indexPath) as! DateTimeTableViewCell
            cell.dateLabel.text = "September 23, 2024"
            cell.timeLabel.text = "04:00 PM"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.basicCell, for: indexPath)
            cell.contentView.backgroundColor = .secondarySystemGroupedBackground
            var content = UIListContentConfiguration.cell()
            content.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
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
