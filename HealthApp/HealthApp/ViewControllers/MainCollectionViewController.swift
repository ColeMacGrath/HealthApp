//
//  MainCollectionViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 09/06/20.
//  Copyright © 2020 Moisés Córdova. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MainCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }

    @IBAction func qrButtonPressed(_ sender: UIBarButtonItem) {
        //Do something
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem) {
        //Do something
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.invalidateLayout()
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var sections = 1
        if section == 1 {
            sections = 5
        } else if section == 2 {
            sections = 6
        }
        
        return sections
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCollectionViewCell
            return cell
        } else if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuickInfoCell", for: indexPath) as! QuickInfoCollectionViewCell
            /*switch indexPath.row {
            case case:
                
            default:
                
            }*/
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
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
                return CGSize(width: width, height: height * 0.2)
            } else if indexPath.section == 1 {
                return CGSize(width: width * 0.05, height: width * 0.05)
            } else {
                return CGSize(width: width * 0.32, height: 200.0)
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
