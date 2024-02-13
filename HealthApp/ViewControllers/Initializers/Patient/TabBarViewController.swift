//
//  TabBarViewController.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 28/12/23.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let primaryViewController = UIStoryboard(name: Constants.Storyboard.dashboard, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewIdentifiers.dashboardNavigationController)
        
        let secondaryViewController = UIStoryboard(name: Constants.Storyboard.doctors, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewIdentifiers.doctorsNC)
        
        
        
        let supplementaryViewController = UIStoryboard(name: Constants.Storyboard.appointments, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewIdentifiers.appointmentsNC)
        
        primaryViewController.tabBarItem = UITabBarItem(title: "Me", image: UIImage.sfSymbol(Constants.SFSymbols.heart, color: .red), selectedImage: UIImage.sfSymbol(Constants.SFSymbols.heartFill, color: .red))
        secondaryViewController.tabBarItem = UITabBarItem(title: "Doctors", image: UIImage.sfSymbol(Constants.SFSymbols.person, color: .red), selectedImage: UIImage.sfSymbol(Constants.SFSymbols.personFill, color: .red))
        supplementaryViewController.tabBarItem = UITabBarItem(title: "Appointments", image: UIImage.sfSymbol(Constants.SFSymbols.calendar, color: .red), selectedImage: UIImage.sfSymbol(Constants.SFSymbols.calendar, color: .red))
        
        // Add the view controllers to the tab bar controller
        self.viewControllers = [primaryViewController, secondaryViewController, supplementaryViewController]
    }
    
}
