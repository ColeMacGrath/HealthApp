//
//  LoginViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 12/06/20.
//  Copyright © 2020 Moisés Córdova. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.addLine()
        self.passwordTextField.addLine()
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ShowForgotPasswordVC", sender: nil)
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        //Do login
    }
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ShowRegisterVC", sender: nil)
    }
    
}
