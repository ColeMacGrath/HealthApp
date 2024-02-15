//
//  SchedulesViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-02-14.
//

import UIKit

class SchedulesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.alwaysBounceVertical = false
    }

}

extension SchedulesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.collectionViewTableViewCell, for: indexPath) as! CollectionViewTableViewCell
            if let collectionView {
                cell.collectionView = collectionView
            } else {
                self.collectionView = cell.collectionView
            }
            return cell
        case 1, 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.datePickerCell, for: indexPath) as! DatePickerTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.basicCell, for: indexPath)
            var content = UIListContentConfiguration.cell()
            content.textProperties.font = UIFont(name: "HelveticaNeue", size: 18.0) ?? UIFont()
            content.textProperties.color = .white
            content.textProperties.alignment = .center
            content.text = "Save"
            cell.contentConfiguration = content
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.section == 0 else {
            return UITableView.automaticDimension
        }
        
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Days"
        case 1:
            return "☀️ Start Time"
        case 2:
            return "🌙 End Time"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 30.0 : 0.0
    }
    
}

extension SchedulesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.singleLabelCell, for: indexPath) as! SingleLabelCollectionViewCell
        var text = String()
        switch indexPath.row {
        case 0:
            text = "M"
        case 1:
            text = "T"
        case 2:
            text = "W"
        case 3:
            text = "T"
        case 4:
            text = "F"
        case 5:
            text = "S"
        default:
            text = "S"
        }
        cell.customizeCell(text: text, selected: Bool.random())
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SingleLabelCollectionViewCell else { return }
        cell.updateSelected()
        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 44.0, height: 44.0)
    }
}
