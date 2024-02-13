//
//  DetailCollectionViewCell.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-02-12.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    func customizeCell(title: String, detail: String) {
        self.titleLabel.text = title
        self.detailLabel.text = detail
    }
}
