//
//  DataCollectionViewCell.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 28/12/23.
//

import UIKit

class DataCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var customBackground: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var customImageView: CacheImageView!
    @IBOutlet weak var valueLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.customBackground.layer.cornerRadius = 8.0
    }
    
    func customizeCell(title: String, value: String, image: UIImage) {
        self.titleLabel.text = title
        self.customImageView.image = image
        self.valueLabel.text = value
    }
}
