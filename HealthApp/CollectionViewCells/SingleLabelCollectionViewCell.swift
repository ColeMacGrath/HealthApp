//
//  SingleLabelCollectionViewCell.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-02-14.
//

import UIKit

class SingleLabelCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    
    func customizeCell(text: String, selected: Bool) {
        self.label.text = text
        self.contentView.backgroundColor = selected ? .systemRed : .secondaryLabel
        self.layoutSubviews()
    }
    
    func updateSelected() {
        self.contentView.backgroundColor = self.contentView.backgroundColor == .secondaryLabel ? .red : .secondaryLabel
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layer.cornerRadius = contentView.frame.size.width / 2
        self.contentView.layer.masksToBounds = true
        let enabled = Bool.random()
        
        if enabled {
            self.contentView.backgroundColor = .red
            self.label.textColor = .white
        } else {
            self.contentView.backgroundColor = .lightGray
            self.label.textColor = .black
        }
    }
}
