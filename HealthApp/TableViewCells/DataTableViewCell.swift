//
//  DataTableViewCell.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 29/12/23.
//

import UIKit

class DataTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var customImageView: CacheImageView!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customizeCell(dataOption: DataOption, roundedImage: Bool = false) {
        self.titleLabel.text = dataOption.title
        self.valueLabel.text = dataOption.value
        self.customImageView.image = dataOption.image
        if roundedImage { self.customImageView.setCircularImage() }
    }
    
    func customizeCell(title: String, value: String, image: UIImage? = nil, imageURL: URL? = nil, roundedImage: Bool = false) {
        self.titleLabel.text = title
        self.valueLabel.text = value
        if let image {
            self.customImageView.image = image
        }
        if let imageURL {
            self.customImageView.loadImageFrom(url: imageURL)
        }
        if roundedImage { self.customImageView.setCircularImage() }
    }

}
