//
//  ViewController.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 28/12/23.
//

import UIKit

class InitialViewController: UIViewController {
    private var loggedIn = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard self.loggedIn else {
            self.performSegue(withIdentifier: Constants.Segues.showLoginViewController, sender: nil)
            return
        }
        
        /*guard let autenticationViewController = UIStoryboard(name: Constants.Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewIdentifiers.authenticationVC) as? AutenticationViewController else { return }
        autenticationViewController.modalPresentationStyle = .fullScreen
        self.present(autenticationViewController, animated: false)*/
        
        /*let presetingViewController = UIDevice.current.userInterfaceIdiom == .phone ? UIStoryboard(name: Constants.Storyboard.tabBar, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewIdentifiers.tabBarViewController) : self.getSplitViewController()
        presetingViewController.modalPresentationStyle = .fullScreen
        self.present(presetingViewController, animated: false)*/
        
        
        let doctorDashboard = UIStoryboard(name: Constants.Storyboard.doctorDashboard, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewIdentifiers.doctorDashboardNC)
        doctorDashboard.modalPresentationStyle = .fullScreen
        self.present(doctorDashboard, animated: false)
        
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


