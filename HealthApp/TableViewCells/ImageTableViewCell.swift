//
//  ImageTableViewCell.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 28/12/23.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var customImageView: CacheImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customizeCell(image: UIImage? = nil, url: URL? = nil, showLines: Bool = false, circular: Bool = true) {
        if circular { self.customImageView.setCircularImage() }
        if let image {
            self.customImageView.image = image
        } else if let url {
            self.customImageView.loadImageFrom(url: url)
        }
        
        self.separatorInset.removeSeparator()
    }

}
