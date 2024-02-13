//
//  AutenticationViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-02-11.
//

import UIKit
import LocalAuthentication

class AutenticationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func verifyButtonPressed(_ sender: UIButton) {
        self.authenticateUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.authenticateUser()
    }
    
    private func checkBiometricAvailability() -> Bool {
        var error: NSError?
        return LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
    private func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else { return }
        let reason = "Please use you Face ID to authenticate you and see you records"
        
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
            DispatchQueue.main.async {
                if success {
                    let presetingViewController = UIDevice.current.userInterfaceIdiom == .phone ? UIStoryboard(name: Constants.Storyboard.tabBar, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewIdentifiers.tabBarViewController) : self.getSplitViewController()
                    presetingViewController.modalPresentationStyle = .fullScreen
                    self.present(presetingViewController, animated: true)
                } else {
                    guard (authenticationError as? LAError)?.code == .authenticationFailed else { return }
                    self.authenticateUser()
                }
            }
        }
        
    }
    
    private func getSplitViewController() -> UISplitViewController {
        let splitViewController = UISplitViewController(style: .tripleColumn)
        splitViewController.preferredDisplayMode = .twoBesideSecondary
        
        let primaryViewController = UIStoryboard(name: Constants.Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewIdentifiers.primaryTableViewController)
        
        let secondaryViewController = UIStoryboard(name: "Doctors", bundle: nil).instantiateViewController(withIdentifier: Constants.ViewIdentifiers.doctorsNC)
        let supplementaryViewController = SupplementaryViewController()
        
        splitViewController.setViewController(primaryViewController, for: .primary)
        splitViewController.setViewController(secondaryViewController, for: .secondary)
        splitViewController.setViewController(supplementaryViewController, for: .supplementary)
        splitViewController.modalPresentationStyle = .fullScreen
        
        return splitViewController
    }
    
}
