//
//  CreateAppointmentViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 7/7/19.
//  Copyright © 2019 Moisés Córdova. All rights reserved.
//
import UIKit

class CreateAppointmentViewController: UIPageViewController {
    
    lazy var orderedControllers: [UIViewController] = {
        return [
            newViewController(storyboardIdentifier: "firstStepVC"),
            newViewController(storyboardIdentifier: "secondStepVC"),
            newViewController(storyboardIdentifier: "doctorListVC"),
            newViewController(storyboardIdentifier: "thirdStepVC"),
            newViewController(storyboardIdentifier: "notesVC"),
            newViewController(storyboardIdentifier: "fourthStepVC"),
            newViewController(storyboardIdentifier: "appointmentVC")
        ]
    }()
    
    var pageControl = UIPageControl()
    var selectedDoctor: Doctor!
    var patient: Patient!
    var createdAppointment: Appointment!
    var selectedDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        if let firstViewController = orderedControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
        configurePageControl()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func newViewController(storyboardIdentifier: String) -> UIViewController {
        
        if storyboardIdentifier == "doctorListVC" {
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: storyboardIdentifier) as! DoctorListViewController
            viewController.isSelectionAllowed = true
            return viewController
        }
        
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: storyboardIdentifier)
    }
    
    func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width: UIScreen.main.bounds.width, height: 50))
        pageControl.numberOfPages = orderedControllers.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.white
        self.view.addSubview(pageControl)
    }
}

extension CreateAppointmentViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedControllers.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard orderedControllers.count > previousIndex else { return nil }
        
        return orderedControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedControllers.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        guard orderedControllers.count != nextIndex else { return nil }
        guard orderedControllers.count > nextIndex  else { return nil }
        
        return orderedControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedControllers.firstIndex(of: pageContentViewController)!
    }
    
}
