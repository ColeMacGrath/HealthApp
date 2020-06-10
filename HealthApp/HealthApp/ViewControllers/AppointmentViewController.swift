//
//  AppointmentViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 10/06/20.
//  Copyright © 2020 Moisés Córdova. All rights reserved.
//

import UIKit

class AppointmentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setTransparent()
    }
}

extension AppointmentViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 || indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageDescriptionCell
            if indexPath.section == 0 {
                cell.descriptionLabel.text = nil
                cell.titleLabel.text = "Doctor Name"
            } else {
                cell.titleLabel.text = nil
                cell.descriptionLabel.text = "djsalsdlkñafsdklfdslkñ"
                cell.cardImage.image = #imageLiteral(resourceName: "clock-icon")
            }
            
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
            cell.textLabel?.text = "jdklñfjksadñfjsñafasfja"
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String? = nil
        if section == 1 {
            title = "Appointment Info"
        } else if section == 2 {
            title = "Notes"
        }
        return title
    }
}
