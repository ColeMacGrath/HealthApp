//
//  PatientProfileViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-02-12.
//

import UIKit

class PatientProfileViewController: UIViewController {
    
    let dataOptions = [
        DataOption(title: "Calories Burned", value: "1324", image:  UIImage(named: "Exercise") ?? UIImage(), color: .blue),
        DataOption(title: "Sleep", value: "7 Hrs", image: UIImage(named: "Sleep") ?? UIImage(), color: .purple),
        DataOption(title: "Weight", value: "85 kgs", image:  UIImage(named: "weight") ?? UIImage(), color: .green),
        DataOption(title: "Hearth BPM", value: "70 Bpm", image: UIImage(named: "Hearth") ?? UIImage(), color: .red),
        DataOption(title: "Ingested Food", value: "Spaghetti", image: UIImage(named: "Eat") ?? UIImage(), color: .systemPink)
    ]
    let favouriteOptions = [
        DataOption(title: "Ingested Food", value: "Spaghetti", image: UIImage(named: "Eat") ?? UIImage(), color: .favourite1),
        DataOption(title: "Weight", value: "85 kgs", image:  UIImage(named: "weight") ?? UIImage(), color: .favourite2),
        DataOption(title: "Hearth BPM", value: "70 Bpm", image: UIImage(named: "Hearth") ?? UIImage(), color: .favourite3),
    ]
    private var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension PatientProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 1
        if section == 0 {
            rows = 2
        } else if section == 2 {
            rows = self.dataOptions.count
        }
        
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard indexPath.row == 1 else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.imageCell, for: indexPath) as! ImageTableViewCell
                cell.customImageView.setCircularImage()
                cell.customImageView.image = .doctor
                cell.separatorInset.removeSeparator()
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.basicCell, for: indexPath)
            var content = UIListContentConfiguration.cell()
            content.text = "Allison Doe"
            content.textProperties.alignment = .center
            content.textProperties.font = UIFont(name: "HelveticaNeue-Medium", size: 22.0) ?? UIFont()
            content.secondaryText = "Female"
            content.secondaryTextProperties.color = .secondaryLabel
            content.secondaryTextProperties.alignment = .center
            content.secondaryTextProperties.font = UIFont(name: "HelveticaNeue", size: 18.0) ?? UIFont()
            cell.contentConfiguration = content
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.collectionViewTableViewCell, for: indexPath) as! CollectionViewTableViewCell
            self.collectionView = cell.collectionView
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataTableViewCell", for: indexPath) as! DataTableViewCell
        cell.customizeCell(dataOption: self.dataOptions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 1 ? 160.0 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 2 else { return nil }
        return "Today Stats"
    }
}

extension PatientProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.favouriteOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.dataCell, for: indexPath) as! DataCellCollectionViewCell
        var favourite = self.favouriteOptions[indexPath.row]
        var stringValue = String.empty
        
        switch indexPath.row {
        case 0:
            stringValue = "Spagetthi"
        case 1:
            stringValue = "65.0 Kgs"
        case 2:
            stringValue = "70.0 BPM"
        default: break
        }
        
        favourite.value = stringValue
        
        cell.customizeCell(image: favourite.image, title: favourite.title, value: favourite.value, color: favourite.color)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.size.height
        let width = view.safeAreaLayoutGuide.layoutFrame.size.width
        
        let device = UIDevice.current
        
        if device.userInterfaceIdiom == .phone {
            return CGSize(width: width * 0.28, height: 150.0)
        }
        return CGSize(width: width * 0.48, height: height * 0.35) //If device is iPad
    }
}
