//
//  ProfileViewController.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 28/12/23.
//

import UIKit
import SwiftUI

class ProfileViewController: UIViewController  {
    
    var person: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 4
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.imageCell, for: indexPath) as! ImageTableViewCell
                cell.customizeCell(image: UIImage(named: "profile") ?? UIImage())
                cell.separatorInset.removeSeparator()
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.textFieldCell) as! TextFieldTableViewCell
            cell.separatorInset.removeSeparator()
            cell.textField.placeholder = "Enter your name"
            cell.textField.text = "John Doe"
            return cell
        } else if indexPath.section == 1 {
            guard indexPath.row != 3 else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.colorCell, for: indexPath) as! ColorTableViewCell
                cell.selectionStyle = .default
                cell.accessoryType = .disclosureIndicator
                var stringValue = String.empty
                
                if let fitzpatrickSkinType = person?.fitzpatrickSkinType { stringValue = fitzpatrickSkinType.type }
                cell.customizeCell(title: "Fitzpatrick Skin Type", value: stringValue, color: person?.fitzpatrickSkinType.color ?? .clear)
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.basicCell, for: indexPath) as! AppointmentTableViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.separatorInset.addSeparator()
            var content = UIListContentConfiguration.cell()
            content.textProperties.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0) ?? UIFont()
            content.secondaryTextProperties.font = UIFont(name: "HelveticaNeue", size: 18.0) ?? UIFont()
            content.secondaryTextProperties.color = .secondaryLabel
            var stringValue = String.empty
            switch indexPath.row {
            case 0:
                content.text = "Biological Sex"
                if let biologicalSex = self.person?.biologicalSex { stringValue = "\(biologicalSex)" }
            case 1:
                content.text = "Age"
                if let age = self.person?.age { stringValue = "\(age)" }
            case 2:
                content.text = "Wheelchair Use"
                stringValue = person?.wheelCharUse ?? false ? "Yes" : "No"
            case 3:
                content.text = "Blood Type"
                if let bloodType = person?.bloodYpe { stringValue = bloodType }
            default: break
            }
            content.secondaryText = stringValue
            cell.contentConfiguration = content
            
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.basicCell, for: indexPath)
            cell.selectionStyle = .default
            cell.backgroundColor = .systemRed
            cell.separatorInset.addSeparator()
            var content = UIListContentConfiguration.cell()
            content.text = "Save"
            content.textProperties.color = .white
            content.textProperties.alignment = .center
            cell.contentConfiguration = content
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            self.performSegue(withIdentifier: Constants.Segues.showFitzpatrickView, sender: nil)

        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 && indexPath.row == 0 ? 150 : UITableView.automaticDimension
    }
}
