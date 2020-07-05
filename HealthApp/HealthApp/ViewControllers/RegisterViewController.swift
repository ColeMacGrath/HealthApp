//
//  RegisterViewController.swift
//  HealthApp
//
//  Created by Moisés on 04/07/20.
//  Copyright © 2020 Moisés Córdova. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension RegisterViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PictureCell") as! PictureTableViewCell
                return cell
            case 1, 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldTableViewCell
                if indexPath.row == 1 {
                    cell.titleLabel.text = "Email"
                    cell.textField.placeholder = "Type your email"
                    cell.textField.keyboardType = .emailAddress
                } else {
                    cell.titleLabel.text = "Password"
                    cell.textField.placeholder = "Type your new password"
                    cell.textField.isSecureTextEntry = true
                }
                return cell
            default:
                break
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell") as! ButtonTableViewCell
        return cell
    }
    
}
