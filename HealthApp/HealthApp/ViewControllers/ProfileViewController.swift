//
//  ProfileViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 7/5/19.
//  Copyright © 2019 Moisés Córdova. All rights reserved.
//

import UIKit
import FloatingPanel

class ProfileViewController: UIViewController, FloatingPanelControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var collectionView: UICollectionView!
    var fpc: FloatingPanelController!
    var backgroundImages: [UIImage] = [
        #imageLiteral(resourceName: "hardBlueGradient"), #imageLiteral(resourceName: "blueGradient"), #imageLiteral(resourceName: "purpleGradient"), #imageLiteral(resourceName: "pinkGradient")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fpc = FloatingPanelController()
        fpc.delegate = self
        let contentVC = storyboard?.instantiateViewController(withIdentifier: "contentVC")
        fpc.set(contentViewController: contentVC)
        
        //fpc.track(scrollView: contentVC.tableView)
        //
        //self.present(fpc, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fpc.removePanelFromParent(animated: true)
    }
    
    
    @IBAction func scanQRButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add a Doctor", message: "How do you want to add a new doctor?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Scan DoctorID", style: .default, handler: { (_) in
            self.fpc.addPanel(toParent: self)
        }))
        alert.addAction(UIAlertAction(title: "Show my PatientID", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Settings", message: "Settings", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileTableViewCell
            cell.nameLabel.text = "Eliza Green"
            cell.roleLabel.text = "Female"
            cell.imageView?.setRounded()
            //cell.imageView?.image = UIImage(named: "profile_picture")
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath) as! CollectionViewTableViewCell
            self.collectionView = cell.collectionView
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! CardTableViewCell
            cell.selectionStyle = .none
            if indexPath.row == 2 {
                cell.titleLabel.text = "Calories Burned"
                cell.topicIcon.image = UIImage(named: "burn-icon")!
                cell.descriptionLabel.text = "This is the count of calories burned with your activity throughout the day"
                cell.quantityLabel.text = "1325"
            } else if indexPath.row == 3 {
                cell.cardView.backgroundColor = #colorLiteral(red: 0.2653386891, green: 0.2729498446, blue: 0.6093763709, alpha: 1)
                cell.titleLabel.text = "Hours sleeping"
                cell.topicIcon.image = UIImage(named: "moon-icon")!
                cell.descriptionLabel.text = "It takes the count of the hours in bed of the last night"
                cell.quantityLabel.text = "7 h"
            } else if indexPath.row == 4 {
                cell.cardView.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                cell.titleLabel.text = "Calories today"
                cell.topicIcon.image = UIImage(named: "food-icon")!
                cell.descriptionLabel.text = "Counting the calories consumed throughout the day, nutrition is important"
                cell.quantityLabel.text = "5380"
            } else if indexPath.row == 5 {
                cell.cardView.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
                cell.titleLabel.text = "Hearth BPM"
                cell.topicIcon.image = UIImage(named: "hearth-icon")!
                cell.descriptionLabel.text = "A record of beats per minute is recorded in different activities"
                cell.quantityLabel.text = "170 bpm"
            } else if indexPath.row == 6 {
                cell.cardView.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
                cell.titleLabel.text = "Nevus Analyzer"
                cell.topicIcon.image = UIImage(named: "bodyScan-icon")!
                cell.descriptionLabel.text = "Detection by artificial intelligence of a nevus' pathology"
                cell.quantityLabel.text = "GO!"
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 70.0
        switch indexPath.row {
        case 1:
            height = 100.0
        default:
            height = 210.0
        }
        
        return height
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DataCollectionCell", for: indexPath) as! DataCollectionViewCell
        cell.bacgroundImage.image = self.backgroundImages[indexPath.row]
        switch indexPath.row {
        case 0:
            cell.dataLabel.text = "10325"
            cell.descriptionLabel.text = "Steps"
        case 1:
            cell.dataLabel.text = "325"
            cell.descriptionLabel.text = "Calories"
        case 2:
            cell.dataLabel.text = "Height"
            cell.descriptionLabel.text = "1.7 m"
        default:
            cell.dataLabel.text = "Weight"
            cell.descriptionLabel.text = "60 kg"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 6 {
            if let viewController = storyboard?.instantiateViewController(withIdentifier: "VisualRecognizerVC") {
                present(viewController, animated: true)
            }
        } else {
            performSegue(withIdentifier: "tableSegue", sender: nil)
        }
    }
    
}
