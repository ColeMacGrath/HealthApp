//
//  MainCollectionViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 09/06/20.
//  Copyright © 2020 Moisés Córdova. All rights reserved.
//

import UIKit

class MainCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate {
    
    let colors: [UIColor] = [#colorLiteral(red: 0.9553055167, green: 0.5355370045, blue: 0.399112761, alpha: 1), #colorLiteral(red: 0.2653386891, green: 0.2729498446, blue: 0.6093763709, alpha: 1), #colorLiteral(red: 0.7770578265, green: 0.445423007, blue: 0.9823502898, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)]
    let titles = ["Calories Burned", "Hours sleeping", "Weight Records", "Hearth BPM", "Food calories", "Nevus Analyzer"]
    let descriptions = ["This is the count of calories burned with your activity throughout the day", "It takes the count of the hours in bed of the last night", "My Last weight measurament on kilograms", "A record of beats per minute is recorded in different activities", "My last food ingested -", "Detection by artificial intelligence of a nevus' pathology"]
    let images: [UIImage] = [#imageLiteral(resourceName: "burn-icon"), #imageLiteral(resourceName: "moon-icon"), #imageLiteral(resourceName: "weight-icon"), #imageLiteral(resourceName: "hearth-icon"), #imageLiteral(resourceName: "food-icon"), #imageLiteral(resourceName: "bodyScan-icon")]
    let quickTitles = ["Steps", "Calories", "Height", "Weight"]
    var healthKitAvailable = false
    let user = User()
    
    var nameLabel: UILabel!
    var genderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setTransparent()
        
        HealthKitService.shared.requestDataTypes { (error) in
            if let error = error {
                print(error)
                //Request to download
            } else {
                HealthKitService.shared.getBiologicalSex { (biologicalSex, _) in
                    guard let biologicalSex = biologicalSex else { return }
                    var sex = ""
                    switch biologicalSex.biologicalSex {
                    case .notSet:
                        sex = "NonSet"
                    case .female:
                        sex = "Female"
                    case .male:
                        sex = "Male"
                    case .other:
                        sex = "Other"
                    @unknown default:
                        sex = ""
                    }
                }
            }
        }
    }
    
    @IBAction func qrButtonPressed(_ sender: UIBarButtonItem) {
        
        #if targetEnvironment(macCatalyst)
        self.createOldMenu(sender: sender)
        #else
        if #available(iOS 13, *) {
            guard let (controller, activityViewController) = storyboard?.createMenu(options: ["Escanear QR", "Mostrar mi QR"], images: [#imageLiteral(resourceName: "qr-icon-scan"), #imageLiteral(resourceName: "qr-icon")], title: "Opciones de QR", image: #imageLiteral(resourceName: "qr-icon")) else { return }
            controller.callback = { selected in
                print("Selected option index: \(selected)")
            }
            
            if let popoverController = activityViewController.popoverPresentationController {
                popoverController.permittedArrowDirections = .any
                popoverController.delegate = self
                popoverController.barButtonItem = sender
            }
            
            self.present(activityViewController, animated: true, completion: nil)
        } else {
            self.createOldMenu(sender: sender)
        }
        #endif
    }
    
    private func createOldMenu(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Opciones de QR", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Escaner QR", style: .default, handler: { (_) in
            //
        }))
        alertController.addAction(UIAlertAction(title: "Mostrar mi QR", style: .default, handler: { (_) in
            //
        }))
        alertController.addAction(UIAlertAction(title: "Cancekar", style: .cancel, handler: { (_) in
            //
        }))
        
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.permittedArrowDirections = .any
            popoverController.delegate = self
            popoverController.barButtonItem = sender
        }
        self.present(alertController, animated: true)
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "ShowEditProfileVC", sender: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.invalidateLayout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            performSegue(withIdentifier: "ShowRecordsVC", sender: nil)
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var sections = 1
        if section == 1 {
            sections = self.quickTitles.count
        } else if section == 2 {
            sections = self.titles.count
        }
        
        return sections
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCollectionViewCell
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuickInfoCell", for: indexPath) as! QuickInfoCollectionViewCell
            cell.titleLabel.text = self.quickTitles[indexPath.row]
            /*switch indexPath.row {
             case case:
             
             default:
             
             }*/
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
            cell.titleLabel.text = self.titles[indexPath.row]
            cell.descriptionLabel.text = self.descriptions[indexPath.row]
            cell.iconImageView.image = self.images[indexPath.row]
            let color = self.colors[indexPath.row]
            cell.gradientView.firstColor = color
            cell.gradientView.secondColor = color
            cell.gradientView.backgroundColor = self.colors[indexPath.row]
            return cell
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.size.height
        let width = view.safeAreaLayoutGuide.layoutFrame.size.width
        
        let device = UIDevice.current
        
        
        if device.userInterfaceIdiom == .pad {
            if indexPath.section == 0 {
                return CGSize(width: width, height: height * 0.25)
            } else if indexPath.section == 1 {
                return CGSize(width: width * 0.06, height: width * 0.06)
            } else {
                return CGSize(width: width * 0.31, height: height * 0.25)
            }
        }
        
        if indexPath.section == 0 {
            return CGSize(width: width, height: 150)
        } else if indexPath.section == 1 {
            if device.orientation.isLandscape {
                return CGSize(width: width * 0.1, height: width * 0.1)
            }
            return CGSize(width: width * 0.13, height: width * 0.13)
        } else {
            if device.orientation.isLandscape {
                return CGSize(width: width * 0.47, height: height * 0.4)
            }
            return CGSize(width: width * 0.9, height: height * 0.22)
        }
    }
    
}
