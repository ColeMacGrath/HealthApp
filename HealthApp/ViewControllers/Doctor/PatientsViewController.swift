//
//  PatientsViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-02-13.
//

import UIKit

class PatientsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
    }
    
}

extension PatientsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.dataTableViewCell, for: indexPath) as! DataTableViewCell
        cell.customizeCell(title: "Allison Doe", value: "Famale\n26 y/o", image: .doctor2, roundedImage: true)
        return cell
    }
}
