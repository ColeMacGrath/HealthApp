//
//  RegisterViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 7/9/19.
//  Copyright © 2019 Moisés Córdova. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    var nameTextField: UITextField!
    var lastNameTextField: UITextField!
    var passwordTextField: UITextField!
    var emailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension RegisterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldTableViewCell
            switch indexPath.row {
            case 0:
                cell.textField.placeholder = "First Name"
                nameTextField = cell.textField
            case 1:
                cell.textField.placeholder = "Last Name"
                lastNameTextField = cell.textField
            case 2:
                cell.textField.keyboardType = .emailAddress
                 emailTextField = cell.textField
                cell.textField.placeholder = "Mail"
           default:
                cell.textField.isSecureTextEntry = true
                passwordTextField = cell.textField
                cell.textField.placeholder = "Password"
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCardTableViewCell
        cell.titleLabel.text = "Register"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 70.0
        if indexPath.row == 4 {
            height = 100.0
        }
        
        return height
    }
}
