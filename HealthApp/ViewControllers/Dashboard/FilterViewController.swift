//
//  FilterViewController.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 30/12/23.
//

import UIKit

class FilterViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var filters: ((_ from: Date?, _ to: Date?) -> Void)?
    var fromDatePicker: UIDatePicker?
    var toDatePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @objc private func datePickerPressed(_ sender: UIDatePicker) {
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 2), at: .top, animated: true)
    }
}

extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section > 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.basicCell, for: indexPath)
            var content = UIListContentConfiguration.cell()
            content.textProperties.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0) ?? UIFont()
            content.textProperties.alignment = .center
            if indexPath.section == 2 {
                cell.backgroundColor = .systemRed
                content.textProperties.color = .white
                content.text = "Save"
            } else {
                cell.backgroundColor = .systemGroupedBackground
                content.textProperties.color = .systemRed
                content.text = "Reset filters"
            }
           
            cell.contentConfiguration = content
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.inlineDatePicker, for: indexPath) as! InlineDatePickerTableViewCell
        if indexPath.section == 0 {
            if let fromDatePicker {
                cell.datePicker = fromDatePicker
            } else {
                self.fromDatePicker = cell.datePicker
            }
            self.fromDatePicker?.addTarget(self, action: #selector(self.datePickerPressed(_:)), for: .valueChanged)
        } else {
            if let toDatePicker {
                cell.datePicker = toDatePicker
            } else {
                self.toDatePicker = cell.datePicker
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2,
           let fromDate = fromDatePicker?.date,
           let toDate = toDatePicker?.date {
            self.dismiss(animated: true) {
                self.filters?(fromDate, toDate)
            }
            
        } else if indexPath.section == 3 {
            self.dismiss(animated: true) {
                self.filters?(nil, nil)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 0 ? 40.0 : 0.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Start Date"
        case 1:
            return "End Date"
        default:
            return nil
        }
    }
}
