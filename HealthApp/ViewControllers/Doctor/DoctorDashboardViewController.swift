//
//  DoctorDashboardViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-02-12.
//

import UIKit

class DoctorDashboardViewController: UIViewController {
    
    @IBOutlet weak var patientInfoCollectionView: UICollectionView!
    @IBOutlet weak var todayPatientsCollectionView: UICollectionView!
    @IBOutlet weak var upcomingPatientPictureCell: UIImageView!
    @IBOutlet weak var upcomingPatientNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.upcomingPatientPictureCell.image = .doctor2
        self.upcomingPatientPictureCell.setCircularImage()
        self.upcomingPatientNameLabel.text = "Allison Doe"
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
        cell.customizeCell(title: "Testing upcoming", detail: "Detail")
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.size.height
        let width = view.safeAreaLayoutGuide.layoutFrame.size.width
        
        if collectionView.tag == 0 {
            return CGSize(width: width * 0.25, height: height * 0.15)
        }
        
        return CGSize(width: width * 0.25, height: height * 0.20)
        
        /*let device = UIDevice.current
         
         if device.userInterfaceIdiom == .phone { //If device is an iPhone
         if device.orientation.isLandscape { //If device is Landscaoe
         return CGSize(width: width * 0.45, height: height * 0.4)
         }
         return CGSize(width: width * 0.95, height: height * 0.3)
         }
         return CGSize(width: width * 0.48, height: height * 0.35) //If device is iPad
         }*/
        
    }
}
