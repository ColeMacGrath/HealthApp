//
//  DoctorDashboardViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-02-12.
//

import UIKit
import SwiftUI

class DoctorDashboardViewController: UIViewController {
    
    @IBOutlet weak var patientInfoCollectionView: UICollectionView!
    @IBOutlet weak var todayPatientsCollectionView: UICollectionView!
    @IBOutlet weak var upcomingPatientPictureCell: UIImageView!
    @IBOutlet weak var upcomingPatientNameLabel: UILabel!
    @IBOutlet weak var upcomingPatientImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.upcomingPatientPictureCell.image = .doctor2
        self.upcomingPatientPictureCell.setCircularImage()
        self.upcomingPatientNameLabel.text = "Allison Doe"
        self.upcomingPatientImageView.layer.borderWidth = 4
        self.upcomingPatientImageView.layer.borderColor = UIColor.white.cgColor
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if let flowLayout = self.patientInfoCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.invalidateLayout()
        }
        if let flowLayout = self.todayPatientsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.invalidateLayout()
        }
    }
    
    @IBAction func seeMoreButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: Constants.Segues.showPatientProfileVC, sender: nil)
    }
    
    @IBAction func qrButtonPressed(_ sender: UIBarButtonItem) {
        let hostingController = UIHostingController(rootView: QRView())
        self.navigationController?.pushViewController(hostingController, animated: true)
    }
    
    
    @IBAction func toolsButtonPressed(_ sender: UIBarButtonItem) {
        guard let viewController = UIStoryboard(name: Constants.Storyboard.doctorSettings, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewIdentifiers.doctorsSettingsVC) as? DoctorSettingsViewController else { return }
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension DoctorDashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.tag == 0 ? 5 : 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.pictureNameCell, for: indexPath) as! PictureNameCollectionViewCell
            cell.customizeCell(picture: .doctor, name: "Testing")
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.detailCell, for: indexPath) as! DetailCollectionViewCell
        
        switch indexPath.row {
        case 0:
            cell.customizeCell(title: "26 y/o", detail: "Age")
        case 1:
            cell.customizeCell(title: "1.72 mts", detail: "Height")
        default:
            cell.customizeCell(title: "65 Kgs", detail: "Weight")
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Constants.Segues.showPatientsVC, sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.size.height
        let width = view.safeAreaLayoutGuide.layoutFrame.size.width
        return collectionView.tag == 0 ? CGSize(width: width * 0.3, height: height * 0.16) : CGSize(width: width * 0.30, height: height * 0.16)
    }
}
