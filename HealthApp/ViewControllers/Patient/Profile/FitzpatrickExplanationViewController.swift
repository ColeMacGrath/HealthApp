//
//  FitzpatrickExplanationViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-01-14.
//

import UIKit
import HealthKit

class FitzpatrickExplanationViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setMinimalBackButton()
    }

}

extension FitzpatrickExplanationViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.basicCell, for: indexPath)
            var content = UIListContentConfiguration.cell()
            content.textProperties.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0) ?? UIFont()
            content.text = "The Fitzpatrick scale is a numerical classification for skin color based on the skins response to sun exposure in terms of the degree of burning and tanning."
            cell.contentConfiguration = content
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.colorCell, for: indexPath) as! ColorTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "I"
            cell.valueLabel.text = "Pale white skin that always burns easily in the sun and never tans."
            cell.colorView.backgroundColor = HealthKitManager.shared.colorForFitzpatrickSkinType(.I)
        case 1:
            cell.titleLabel.text = "II"
            cell.valueLabel.text = "White skin that burns easily and tans minimally."
            cell.colorView.backgroundColor = HealthKitManager.shared.colorForFitzpatrickSkinType(.II)
        case 2:
            cell.titleLabel.text = "III"
            cell.valueLabel.text = "White to light brown skin that burns moderately and tans uniformly."
            cell.colorView.backgroundColor = HealthKitManager.shared.colorForFitzpatrickSkinType(.III)
        case 3:
            cell.titleLabel.text = "IV"
            cell.valueLabel.text = "Beige-olive, lightly tanned skin that burns minimally and tans moderately."
            cell.colorView.backgroundColor = HealthKitManager.shared.colorForFitzpatrickSkinType(.IV)
        case 4:
            cell.titleLabel.text = "V"
            cell.valueLabel.text = "Brown skin that rarely burns and tans profusely."
            cell.colorView.backgroundColor = HealthKitManager.shared.colorForFitzpatrickSkinType(.V)
        case 5:
            cell.titleLabel.text = "VI"
            cell.valueLabel.text = "Dark brown to black skin that never burns and tans profusely."
            cell.colorView.backgroundColor = HealthKitManager.shared.colorForFitzpatrickSkinType(.VI)
        default: break
        }
        return cell
    }
    
    
}
