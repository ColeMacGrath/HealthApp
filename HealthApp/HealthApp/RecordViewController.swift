//
//  RecordViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 7/7/19.
//  Copyright © 2019 Moisés Córdova. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {
    
    var records: [Record] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRecords(number: 10)
    }
    
    func getRecords(number: Int) {
        for _ in 0..<number {
            let record = Record(record: "170 BPM", date: "Dec 16, 2019")
            records.append(record)
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension RecordViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return records.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecordMainCell", for: indexPath) as! RecordMainTableViewCell
            cell.titleRecord.text = "Calories Burned"
            cell.dateRecord.text = "Today, Dec 16"
            cell.imageRecord.image = UIImage(named: "burn-icon")!
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath)
        cell.textLabel?.text = records[indexPath.row].record
        cell.detailTextLabel?.text = records[indexPath.row].date
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 50.0
        if indexPath.section == 0 {
            height = 300.0
        }
        return height
    }
    
}

struct Record {
    var record = ""
    var date = ""
    
    init(record: String, date: String) {
        self.record = record
        self.date = date
    }
}
