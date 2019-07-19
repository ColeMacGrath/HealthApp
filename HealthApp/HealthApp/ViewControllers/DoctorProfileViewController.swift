//
//  DoctorProfileViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 7/6/19.
//  Copyright © 2019 Moisés Córdova. All rights reserved.
//

import UIKit

class DoctorProfileViewController: UIViewController {
    
    let options = ["Personal Info", "Address"]
    let images: [UIImage] = [#imageLiteral(resourceName: "person-icon"),#imageLiteral(resourceName: "map-icon")]
    var doctor: Doctor!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
        // Do any additional setup after loading the view.
    }
    
    @IBAction func mapButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func phoneButtonPressed(_ sender: UIButton) {
    }

}

extension DoctorProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sections = 0
        switch section {
        case 0:
            sections = 1
        case 1:
            sections = 1
        case 2:
            sections = 2
        default:
            break
        }
        return sections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! DoctorProfileTableViewCell
            cell.profileImageView.image = doctor.profilePicture ?? UIImage(named: "doctor_female")!
            cell.nameLabel.text = "\(doctor.firstName) \(doctor.lastName)"
            cell.specialityLabel.text = doctor.specialty
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCardTableViewCell
            cell.titleLabel.text = "Make an Appointment"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! TableItemCardTableViewCell
            cell.itemImageView.image = images[indexPath.row]
            cell.itemLabel.text = options[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 100.0
        if indexPath.section == 0 {
            height = 250.0
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*if indexPath.row == 0 && indexPath.section == 1 {
            if let viewController = storyboard?.instantiateViewController(withIdentifier: "CreateAppointmentVC") {
                //present(viewController, animated: true)
            }
        }*/
    }
}
