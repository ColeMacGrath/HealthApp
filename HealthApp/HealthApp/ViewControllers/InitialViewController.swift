//
//  InitialViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 09/06/20.
//  Copyright © 2020 Moisés Córdova. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    var sessionActive = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if sessionActive {
            self.performSegue(withIdentifier: "ShowMainVC", sender: nil)
        } else {
            guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController else { return }
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: false)
        }
    }

}
