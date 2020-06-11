//
//  ChartCollectionViewCell.swift
//  HealthApp
//
//  Created by Moisés Córdova on 11/06/20.
//  Copyright © 2020 Moisés Córdova. All rights reserved.
//

import UIKit
import Charts

class ChartCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImageview: UIImageView!
    @IBOutlet weak var chartView: BarChartView!
}
