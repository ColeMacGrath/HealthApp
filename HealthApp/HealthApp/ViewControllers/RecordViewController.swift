//
//  RecordViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 7/7/19.
//  Copyright © 2019 Moisés Córdova. All rights reserved.
//

import UIKit
import Charts

class RecordViewController: UIViewController {
    
    var records: [Record] = []
    var mainColor: UIColor!
    var mainIcon: UIImage!
    var recordTitle: String!
    let days = ["sun", "mon", "tue", "wed", "thur", "sat"]
    let data = [150.0, 250.0 ,574.0, 152.0, 178.0, 785.0]
    var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: mainColor!]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: mainColor!]
        getRecords(number: 10)
    }
    
    func createChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
        let chartData = BarChartData(dataSet: chartDataSet)
        
        barChartView.data = chartData
        chartDataSet.colors = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        barChartView.leftAxis.enabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.legend.enabled = false
        
        
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
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
            self.barChartView = cell.barChartView
            self.createChart(dataPoints: days, values: data)
            cell.cardView.backgroundColor = mainColor
            cell.titleRecord.text = recordTitle
            cell.dateRecord.text = "Last Records"
            cell.imageRecord.image = mainIcon
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
