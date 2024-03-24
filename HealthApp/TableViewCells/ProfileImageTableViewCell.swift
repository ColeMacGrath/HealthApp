//
//  ProfileImageTableViewCell.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 29/12/23.
//

import UIKit
import CoreImage

class ProfileImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var customImageView: CacheImageView!
    @IBOutlet weak var customTitleLabel: UILabel!
    @IBOutlet weak var customDetailLabel: UILabel!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.configureGradientMask()
    }

    
    func customizeCell(imageURL: URL?, title: String?, detail: String?) {
        self.customImageView.loadImageFrom(url: imageURL)
        self.customTitleLabel.text = title
        self.customDetailLabel.text = detail
        self.configureGradientMask()
        
        
    }
    
    func configureGradientMask() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = visualEffectView.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0.0, 0.7]  // Adjust these values to control the gradient effect
        visualEffectView.layer.mask = gradientLayer
    }
    
    
    
    
}
