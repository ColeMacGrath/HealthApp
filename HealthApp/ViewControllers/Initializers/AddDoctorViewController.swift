//
//  AddDoctorViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-01-25.
//

import UIKit

class AddDoctorViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isModalInPresentation = true
        self.tableView.alwaysBounceVertical = false
    }
    @IBAction func addButtonPressed(_ sender: UIButton) {
        sender.showLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            sender.hideLoading(title: "Added")
            self.dismiss(animated: true)
        })
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

extension AddDoctorViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0,
           indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.imageCell, for: indexPath) as! ImageTableViewCell
            cell.custommizeCell(image: .doctor, showLines: false, circular: true)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.basicCell, for: indexPath)
        var content = UIListContentConfiguration.cell()
        
        if indexPath.section == 0 {
            cell.backgroundColor = .clear
            content.textProperties.alignment = .center
            content.text = "John Doe"
            content.textProperties.font = UIFont(name: "HelveticaNeue-Bold", size: 22.0) ?? UIFont()
            content.secondaryText = "Cardiologyst"
            content.secondaryTextProperties.font = UIFont(name: "HelveticaNeue", size: 16.0) ?? UIFont()
            content.secondaryTextProperties.color = .secondaryLabel
            content.secondaryTextProperties.alignment = .center
        } else {
            cell.backgroundColor = .secondarySystemGroupedBackground
            content.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
            content.textProperties.font = UIFont(name: "HelveticaNeue", size: 16.0) ?? UIFont()
            content.textProperties.color = .secondaryLabel
        }
        
        cell.contentConfiguration = content
        
        return cell
    }
}
