//
//  RecordViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 11/06/20.
//  Copyright © 2020 Moisés Córdova. All rights reserved.
//

import UIKit
import Charts

class RecordViewController: UIViewController {
    
    var barChartView: BarChartView!
    var values: [Double] = [10, 30, 10, 15, 12]
    var dataPoints: [String] = ["Sun", "Mon", "Tue", "Sat", "Wed"]
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.invalidateLayout()
    }
    
    func create(barChartView: BarChartView, dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<values.count {
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
    
}

extension RecordViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var sections = 1
        if section == 1 {
            sections = 10
        }
        
        return sections
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChartCell", for: indexPath) as! ChartCollectionViewCell
            self.create(barChartView: cell.chartView, dataPoints: self.dataPoints, values: self.values)
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCell", for: indexPath) as! DescriptionCollectionViewCell
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.size.height
        let width = view.safeAreaLayoutGuide.layoutFrame.size.width
        
        let device = UIDevice.current
        
        if device.userInterfaceIdiom == .phone { //If device is an iPhone
            if indexPath.section == 0 {
                return CGSize(width: width * 0.95, height: height * 0.3)
            }
            return CGSize(width: Double(width) * 0.95, height: 80.0)
        }
        
        if indexPath.section == 0 {
            return CGSize(width: width * 0.4, height: height * 0.35)
        }
        return CGSize(width: width * 0.48, height: 80.0) //If device is iPad
    }
    
}
