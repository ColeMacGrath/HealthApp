//
//  PermissionsViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-01-15.
//

import UIKit

class PermissionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        HealthKitManager.shared.requestAuthorization { allowed, _ in
            guard !allowed else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
                return
            }
        }
    }
    
    @IBAction func allowAccessButtonPressed(_ sender: UIButton) {
        guard let url = URL(string: "x-apple-health://") else { return }
        UIApplication.shared.open(url)
    }

}
