//
//  CreateAppoimentViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 1/1/19.
//  Copyright © 2019 Moisés Córdova. All rights reserved.
//

import UIKit
import FirebaseAuth
import SCLAlertView

class CreateAppointmentViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as! NameCell
            cell.nameLabel.text = "Juan Gabriel Gomila Salas"
            cell.profilePictureImageView.image = UIImage(named: "picture")
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
            cell.noteTextView.text = ""
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PickerCell", for: indexPath) as! DatePickerCell
            //cell.datePicker(self)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonSaveCell", for: indexPath) as! ButtonCell
            cell.button.setImage(UIImage(named: "button-light"), for: .normal)
            cell.button.setTitle("Save", for: .normal)
            return cell
        }
        
    }
    
    
    
    
    /*@IBAction func pickerView(_ sender: UIDatePicker) {
        var components = Calendar.current.dateComponents([.hour, .minute, .month, .year, .day], from: sender.date)
        
        if components.hour! < 7 {
            components.hour = 7
            components.minute = 0
            SCLAlertView().showNotice("Too Early", subTitle: "The doctor isn't available in that hour, choose other")
            sender.setDate(Calendar.current.date(from: components)!, animated: true)
        } else if components.hour! > 21 {
            components.hour = 21
            components.minute = 59
            SCLAlertView().showNotice("Too Late", subTitle: "The doctor isn't available in that hour, choose other")
            sender.setDate(Calendar.current.date(from: components)!, animated: true)
        }
    }*/

}
