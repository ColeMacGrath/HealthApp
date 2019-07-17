//
//  LoginViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 7/9/19.
//  Copyright © 2019 Moisés Córdova. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var mailTextField: UITextField!
    var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension LoginViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldTableViewCell
            cell.textField.placeholder = "Type your mail"
            cell.textField.keyboardType = .emailAddress
            self.mailTextField = cell.textField
             return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldTableViewCell
            cell.textField.placeholder = "Type your password"
            cell.textField.isSecureTextEntry = true
            self.passwordTextField = cell.textField
             return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCardTableViewCell
            cell.titleLabel.text = "Login"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 80.0
        if indexPath.row == 2 {
            height = 100.0
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            if let email = mailTextField.text, let password = passwordTextField.text, (email.count > 0 && password.count > 3) {
                AuthService.shared.login(email: email, password: password, onComplete: {
                    (message, data) in
                    
                    guard message == nil else {
                        let alert = UIAlertController(title: "Error found", message: message, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        return
                    }
                    self.dismiss(animated: true, completion: nil)
                    //Ir a la pantalla principal
                    
                })
                
            } else {
                let alert = UIAlertController(title: "Data incomplete", message: "Fill all fields", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
}
