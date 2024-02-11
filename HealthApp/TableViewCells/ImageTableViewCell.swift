//
//  ImageTableViewCell.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 28/12/23.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var customImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func custommizeCell(image: UIImage, showLines: Bool = false, circular: Bool = true) {
        if circular { self.customImageView.setCircularImage() }
        self.customImageView.image = image
        self.separatorInset.removeSeparator()
    }

}
