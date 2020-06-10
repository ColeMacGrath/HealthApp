//
//  DoctorProfileViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 09/06/20.
//  Copyright © 2020 Moisés Córdova. All rights reserved.
//

import UIKit

class DoctorProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let titles = ["Make an Appointment", "Show in Maps", "Contact"]
    
    let images: [UIImage] = [#imageLiteral(resourceName: "appointmnet-icon"), #imageLiteral(resourceName: "map-icon"), #imageLiteral(resourceName: "phone-icon")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension DoctorProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sections = 1
        if section == 1 {
            sections = self.titles.count
        }
        
        return sections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! DoctorProfileTableViewCell
            if self.title == nil {
                cell.nameLabel.text = "Seleccione un médico"
            } else {
                cell.nameLabel.text = self.title
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageDescriptionCell
        cell.titleLabel.text = self.titles[indexPath.row]
        cell.descriptionLabel.text = "TO DO"
        cell.cardImage.image = self.images[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
