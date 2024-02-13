//
//  DashboardViewController.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 28/12/23.
//

import UIKit
import HealthKit
import SwiftUI

struct DataOption {
    var title: String
    var value: String
    var image: UIImage
    var color: UIColor
}

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var profileButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    private var collectionView: UICollectionView?
    private var caloriesBurned: Int?
    private var sleepHours: Int?
    private var weight: Double?
    private var hearthRate: Int?
    private var lastIngestedFood: (foodName: String, calories: Double)?
    private var biologicalSex: String?
    private var fitzpatrickSkinType: (type: String, color: UIColor)?
    private var wheelCharUse: Bool?
    private var bloodType: String?
    private var age: Int?
    private var person: Person?
    var selectedIdentifier: HKQuantityTypeIdentifier?
  
    let favouriteOptions = [
        DataOption(title: "Ingested Food", value: "Spaghetti", image: UIImage(named: "Eat") ?? UIImage(), color: .favourite1),
        DataOption(title: "Weight", value: "85 kgs", image:  UIImage(named: "weight") ?? UIImage(), color: .favourite2),
        DataOption(title: "Hearth BPM", value: "70 Bpm", image: UIImage(named: "Hearth") ?? UIImage(), color: .favourite3),
    ]
    var dataOptions = [
        DataOption(title: "Calories Burned", value: "1324", image:  UIImage(named: "Exercise") ?? UIImage(), color: .blue),
        DataOption(title: "Sleep", value: "7 Hrs", image: UIImage(named: "Sleep") ?? UIImage(), color: .purple),
        DataOption(title: "Weight", value: "85 kgs", image:  UIImage(named: "weight") ?? UIImage(), color: .green),
        DataOption(title: "Hearth BPM", value: "70 Bpm", image: UIImage(named: "Hearth") ?? UIImage(), color: .red),
        DataOption(title: "Ingested Food", value: "Spaghetti", image: UIImage(named: "Eat") ?? UIImage(), color: .systemPink),
        DataOption(title: "Nevus Analyzer", value: "AI Nevus Analyzer", image: UIImage(named: "Nevus") ?? UIImage(), color: .cyan)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == Constants.Segues.showEditProfileViewController,
           let destinationNavigationController = segue.destination as? UINavigationController,
           let destinationViewController = destinationNavigationController.children.first as? ProfileViewController {
            destinationViewController.person = self.person
        } else if segue.identifier == Constants.Segues.showHistoryVC,
                  let destination = segue.destination as? HistoryViewController,
                  let selectedIdentifier {
            destination.healthIdentifier = selectedIdentifier
        } else if segue.identifier == Constants.Segues.showPermissionsViewController {
            let destinationVC = segue.destination
            destinationVC.isModalInPresentation = true
        }
    }
    
    @IBAction func qrButtonPressed(_ sender: UIBarButtonItem) {
        let hostingController = UIHostingController(rootView: QRView())
        self.navigationController?.pushViewController(hostingController, animated: true)
    }
    
    @IBAction func profileButtonPressed(_ sender: UIBarButtonItem) {
        guard person != nil else { return }
        self.performSegue(withIdentifier: Constants.Segues.showEditProfileViewController, sender: nil)
    }
    
    @objc private func showEditProfile() {
        self.performSegue(withIdentifier: Constants.Segues.showEditProfileViewController, sender: nil)
    }
    
    private func requestData() {
        HealthKitManager.shared.requestAuthorization { success, _ in
            guard success else {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: Constants.Segues.showPermissionsViewController, sender: nil)
                }
                return
            }
            
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            HealthKitManager.shared.getFitzpatrickSkinType { skinType, color  in
                guard let skinType,
                      let color else { return }
                self.fitzpatrickSkinType = (skinType, color)
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            HealthKitManager.shared.getWheelchairUse { wheelCharUse in
                self.wheelCharUse = wheelCharUse
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            HealthKitManager.shared.getBloodType { bloodType in
                self.bloodType = bloodType
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            HealthKitManager.shared.getAge { age in
                self.age = age
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            HealthKitManager.shared.getBiologicalSex { biologicalSex in
                self.biologicalSex = biologicalSex
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            HealthKitManager.shared.fetchLastIngestedFood { food in
                self.lastIngestedFood = food
                dispatchGroup.leave()
            }
            
            if let unit = HealthKitManager.shared.getUnitFor(identifier: .activeEnergyBurned) {
                dispatchGroup.enter()
                HealthKitManager.shared.quantityRecordsFor(typeIdentifier: .activeEnergyBurned, withUnit: unit, from: Date.today, to: Date()) { values in
                    self.caloriesBurned = Int(values.reduce(0.0) { $0 + $1.value })
                    dispatchGroup.leave()
                }
            }
            
            if let unit = HealthKitManager.shared.getUnitFor(identifier: .bodyMass) {
                dispatchGroup.enter()
                HealthKitManager.shared.latestQuantityRecordFor(typeIdentifier: .bodyMass, withUnit: unit) { value in
                    self.weight = value?.value ?? 0.0
                    dispatchGroup.leave()
                }
            }
            
            if let unit = HealthKitManager.shared.getUnitFor(identifier: .heartRate) {
                dispatchGroup.enter()
                HealthKitManager.shared.latestQuantityRecordFor(typeIdentifier: .heartRate, withUnit: unit) { value in
                    self.hearthRate = Int(value?.value ?? 0.0)
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.enter()
            HealthKitManager.shared.categoryRecordsFor(typeIdentifier: .sleepAnalysis, from: Date.distantPast, to: Date()) { samples, _ in
                guard let samples,
                      let latestSleep = HealthKitManager.shared.findLatestContinuousSleepSession(from: samples),
                      let hours = latestSleep.start.differenceBetween(date: latestSleep.end)?.hours else { return }
                self.sleepHours = hours
                dispatchGroup.leave()
            }
            
            
            dispatchGroup.notify(queue: .main) {
                self.tableView.reloadData()
                self.collectionView?.reloadData()
                guard let age = self.age,
                      let biologicalSex = self.biologicalSex,
                      let wheelCharUse = self.wheelCharUse,
                      let fitzpatrickSkinType = self.fitzpatrickSkinType,
                      let bloodType = self.bloodType else { return }
                self.person = Person(name: "John Doe", age: age, biologicalSex: biologicalSex, wheelCharUse: wheelCharUse, fitzpatrickSkinType: fitzpatrickSkinType, bloodYpe: bloodType)
                
            }
        }
    }
    
}

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        default:
            return self.dataOptions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.imageCell, for: indexPath) as! ImageTableViewCell
                
                cell.customizeCell(image: UIImage(named: "profile") ?? UIImage())
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.basicCell, for: indexPath)
            cell.separatorInset.removeSeparator()
            var content = UIListContentConfiguration.cell()
            content.text = "John Doe"
            content.textProperties.color = .label
            content.textProperties.font = UIFont(name: "HelveticaNeue-Bold", size: 25.0) ?? UIFont()
            content.textProperties.alignment = .center
            content.secondaryTextProperties.color = .secondaryLabel
            content.secondaryText = self.person?.biologicalSex ?? "Not Set"
            content.secondaryTextProperties.alignment = .center
            content.secondaryTextProperties.font = UIFont(name: "HelveticaNeue-Light", size: 18.0) ?? UIFont()
            cell.contentConfiguration = content
            return cell
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.collectionViewTableViewCell, for: indexPath) as! CollectionViewTableViewCell
            self.collectionView = cell.collectionView
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.dataTableViewCell, for: indexPath) as! DataTableViewCell
        var dataOption = self.dataOptions[indexPath.row]
        var stringValue = String.empty
        switch indexPath.row {
        case 0:
            if let caloriesBurned { stringValue = "\(caloriesBurned)" }
        case 1:
            if let sleepHours { stringValue = "\(sleepHours)"}
        case 2:
            if let weight { stringValue = "\(weight)" }
        case 3:
            if let hearthRate { stringValue = "\(hearthRate)"}
        case 4:
            if let lastIngestedFood { stringValue = lastIngestedFood.foodName }
        case 5:
            stringValue = "GO"
        default: break
        }
        dataOption.value = stringValue
        cell.customizeCell(title: dataOption.title, value: dataOption.value, image: dataOption.image)
        cell.separatorInset.addSeparator()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 2 { return }
        
        switch indexPath.row {
        case 0:
            self.selectedIdentifier = .activeEnergyBurned
        case 1:
            self.performSegue(withIdentifier: Constants.Segues.showSleepHistoryVC, sender: nil)
            return
        case 2:
            self.selectedIdentifier = .bodyMass
        case 3:
            self.selectedIdentifier = .heartRate
        case 4:
            self.performSegue(withIdentifier: Constants.Segues.showCaloriesSummaryViewController, sender: nil)
        case 5:
            let scannerView = ScannerView(scanType: .nevus, description: "Center nevus in the sqaure and then press capture button") { nevusImage in
                guard let nevusImage else { return }
            }
            self.selectedIdentifier = nil
            let hostingController = UIHostingController(rootView: scannerView)
            self.present(hostingController, animated: true)
        default:
            self.selectedIdentifier = nil
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard self.selectedIdentifier != nil else { return }
        self.performSegue(withIdentifier: Constants.Segues.showHistoryVC, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 1 ? 160.0 : UITableView.automaticDimension
    }
}

extension DashboardViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
            if let weight { stringValue = "\(weight)" }
        case 2:
            if let hearthRate {  stringValue = "\(hearthRate)" }
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
