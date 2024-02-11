//
//  LabelButtonTableViewCell.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 28/12/23.
//

import UIKit

class LabelButtonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var customLabel: UILabel!
    var selectedValueCallback: ((Int) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setMenu()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func setMenu() {
        guard let button else { return }
        let maleAction = UIAction(title: "Male", image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { action in
            self.selectedValueCallback?(0)
        }
        let femaleAction = UIAction(title: "Female", image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { action in
            self.selectedValueCallback?(1)
        }
        let otherAction = UIAction(title: "Not Set", image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { action in
            self.selectedValueCallback?(2)
        }
        
        let menu = UIMenu(title: "", children: [maleAction, femaleAction, otherAction])
        button.menu = menu
        button.showsMenuAsPrimaryAction = true
    }
    
}
