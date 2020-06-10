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
            sections = 4
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
        return cell
    }
}
