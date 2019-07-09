//
//  DoctorListViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 7/6/19.
//  Copyright © 2019 Moisés Córdova. All rights reserved.
//

import UIKit

class DoctorListViewController: UIViewController {
    
    var buttonImages: [UIImage] = [#imageLiteral(resourceName: "blue_button"), #imageLiteral(resourceName: "pink_button"), #imageLiteral(resourceName: "green_button"), #imageLiteral(resourceName: "blue_button"), #imageLiteral(resourceName: "aqua_button")]
    
    var specialityNames: [String] = [
        "Psychiatrist",
        "Allergist",
        "Urologist",
        "Podiatrist",
        "Neurologist"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

extension DoctorListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let random = Int.random(in: 0..<specialityNames.count)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactTableViewCell
        cell.profileImageView.image = UIImage(named: "doctor_female")!
        cell.nameLabel.text = "Sussan Gwen"
        cell.specialistButton.setTitle(specialityNames[random], for: .normal)
        cell.specialistButton.setBackgroundImage(buttonImages[random], for: .normal)
        return cell
    }
}
