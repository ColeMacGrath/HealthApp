//
//  InitialViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 7/9/19.
//  Copyright © 2019 Moisés Córdova. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    var logged = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        if logged {
            performSegue(withIdentifier: "showMainPageTBC", sender: nil)
            return
        }
        
        performSegue(withIdentifier: "showLoginVC", sender: nil)
    }
}
