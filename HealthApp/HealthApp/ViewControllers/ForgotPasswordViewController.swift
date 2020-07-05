//
//  ForgotPasswordViewController.swift
//  HealthApp
//
//  Created by Moisés on 04/07/20.
//  Copyright © 2020 Moisés Córdova. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var mailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mailTextField.addLine()
    }
    
    @IBAction func canceLButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        //Recover password here
    }
    
}
