//
//  PatientProfileViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-02-12.
//

import UIKit

class PatientProfileViewController: UIViewController {
    private var dataOptions = [DataOption]()
    var favouriteOptions = [DataOption]()
    private var collectionView: UICollectionView?
    @IBOutlet weak var tableView: UITableView!
    var patient: Patient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let healthData = patient.healthData else { return }
        self.loadFavouriteOptions(healthData: healthData)
        self.loadDataOptions(healthData: healthData)
    }
    
    private func loadFavouriteOptions(healthData: HealthDataStructure) {
        let healthData = self.patient.healthData
        if let lastIngestedFood = healthData?.ingestedFood.last {
            self.favouriteOptions.append(DataOption(title: "Ingested Food", value: lastIngestedFood.foodName, image: UIImage(named: "Eat") ?? UIImage(), color: .favourite1))
        }
        if let lastWeight = healthData?.weight.last {
            self.favouriteOptions.append(DataOption(title: "Weight", value: "\(lastWeight.kilograms) kgs", image:  UIImage(named: "weight") ?? UIImage(), color: .favourite2))
        }
        if let lastHearthBPM = healthData?.hearthBPM.last {
            self.favouriteOptions.append(DataOption(title: "Hearth BPM", value: "\(lastHearthBPM.BPM) Bpm", image: UIImage(named: "Hearth") ?? UIImage(), color: .favourite3))
        }
    }
    
    private func loadDataOptions(healthData: HealthDataStructure) {
        if let caloriesBurned = healthData.caloriesBurned.last {
            self.dataOptions.append(DataOption(title: "Calories Burned", value: "\(caloriesBurned.calories)", image:  UIImage(named: "Exercise") ?? UIImage(), color: .blue))
        }
        if let sleep = healthData.sleep.last,
           let time = sleep.startDate.differenceBetween(date: sleep.endDate) {
            self.dataOptions.append(DataOption(title: "Sleep", value: "\(time.hours) Hrs", image: UIImage(named: "Sleep") ?? UIImage(), color: .purple))
        }
        if let weight = healthData.weight.last {
            self.dataOptions.append(DataOption(title: "Weight", value: "\(weight.kilograms) kgs", image:  UIImage(named: "weight") ?? UIImage(), color: .green))
        }
        if let hearthBPM = healthData.hearthBPM.last {
            self.dataOptions.append(DataOption(title: "Hearth BPM", value: "\(hearthBPM.BPM) Bpm", image: UIImage(named: "Hearth") ?? UIImage(), color: .red))
        }
        if let ingestedFood = healthData.ingestedFood.last {
            self.dataOptions.append(DataOption(title: "Ingested Food", value: "\(ingestedFood.foodName)", image: UIImage(named: "Eat") ?? UIImage(), color: .systemPink))
        }
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
                cell.customImageView.loadImageFrom(url: self.patient.profilePicture)
                cell.separatorInset.removeSeparator()
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.basicCell, for: indexPath)
            var content = UIListContentConfiguration.cell()
            content.text = self.patient.fullName
            content.textProperties.alignment = .center
            content.textProperties.font = UIFont(name: "HelveticaNeue-Medium", size: 22.0) ?? UIFont()
            content.secondaryText = self.patient.biologicalSex
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
        let favourite = self.favouriteOptions[indexPath.row]
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
