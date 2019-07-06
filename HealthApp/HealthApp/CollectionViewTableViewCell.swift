//
//  CollectionViewTableViewCell.swift
//  HealthApp
//
//  Created by Moisés Córdova on 7/5/19.
//  Copyright © 2019 Moisés Córdova. All rights reserved.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
