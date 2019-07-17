//
//  InitialViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 7/9/19.
//  Copyright © 2019 Moisés Córdova. All rights reserved.
//

import UIKit
import FirebaseAuth

class InitialViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        guard Auth.auth().currentUser != nil else {
            performSegue(withIdentifier: "showLoginVC", sender: nil)
            return
        }
        performSegue(withIdentifier: "showMainPageTBC", sender: nil)
        
    }
}
