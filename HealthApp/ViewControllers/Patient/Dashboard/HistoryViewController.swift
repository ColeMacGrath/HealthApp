//
//  HistoryViewController.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 29/12/23.
//

import UIKit
import SwiftUI
import HealthKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    private let alert = UIAlertController(title: nil, message: "Loading data...", preferredStyle: .alert)
    private let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    var healthIdentifier: HKQuantityTypeIdentifier!
    var appliedFilter = false
    var healthRecords = [GenericHealthData]()
    var from: Date?
    var to: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingIndicator.hidesWhenStopped = true
        self.loadingIndicator.style = UIActivityIndicatorView.Style.medium
        self.alert.view.addSubview(loadingIndicator)
        self.loadData()
    }
    
    @IBAction @objc func filterButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.Segues.showFilterVC, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let destination = segue.destination as? FilterViewController else { return }
        destination.filters = { [weak self] (from, to) in
            guard let self else { return }
            self.from = from
            self.to = to
            self.appliedFilter = self.from != nil && self.to != nil
            self.loadData()
        }
    }
    
    private func loadData() {
        guard let unit = HealthKitManager.shared.getUnitFor(identifier: self.healthIdentifier) else { return }
        let initalDate = from ?? Date().onPast(days: self.daysFor(identifier: self.healthIdentifier))
        let finalDate = to ?? Date()
        HealthKitManager.shared.quantityRecordsFor(typeIdentifier: self.healthIdentifier, withUnit: unit, from: initalDate, to: finalDate) { records in
            let healthRecords = records.map { GenericHealthData(value: $0.value, date: $0.date) }
            DispatchQueue.main.async {
                guard !healthRecords.isEmpty else {
                    self.showFloatingAlert(text: "No records available", alertType: .warning)
                    return
                }
                self.healthRecords = healthRecords
                self.tableView.reloadData()
                self.updateRightBarButtonImage()
            }
        }
    }
    
    private func updateRightBarButtonImage() {
        let image = self.appliedFilter ? UIImage.sfSymbol("line.3.horizontal.decrease.circle.fill", color: .systemRed) : UIImage.sfSymbol("line.3.horizontal.decrease.circle", color: .systemRed)
        self.filterButton.image = image
    }
    
    private func daysFor(identifier: HKQuantityTypeIdentifier) -> Int {
        switch identifier {
        case .bodyMass:
            return .year
        case .heartRate, .activeEnergyBurned:
            return .aDay
        default:
            return .week
        }
    }
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : self.healthRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section != 0 else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.basicCell, for: indexPath)
            
            cell.contentConfiguration = UIHostingConfiguration {
                LineChart(healthRecords: self.healthRecords)
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.historyRecordCell, for: indexPath) as! HistoryRecordsTableViewCell
        let healtDataRow = self.healthRecords[indexPath.row]
        cell.customizeCell(date: healtDataRow.date.longDate, value: "\(healtDataRow.value)", time: healtDataRow.date.twelveHoursFormmatedHour)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.section == 0 ? 250 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 1 ? "Records" : nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
}


