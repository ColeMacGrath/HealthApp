//
//  SleepHistoryViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-01-26.
//

import UIKit

class SleepHistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setMinimalBackButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.cleanNavigation()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.defaultNavigation()
    }

}

extension SleepHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 3 ? 10 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0, 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.basicCell, for: indexPath)
            var content = UIListContentConfiguration.cell()
            content.textProperties.alignment = .center
            if indexPath.section == 0 {
                cell.selectionStyle = .none
                content.textProperties.font = UIFont(name: "HelveticaNeue-Bold", size: 30.0) ?? UIFont()
                content.textProperties.color = .white
                content.secondaryTextProperties.font = UIFont(name: "HelveticaNeue", size: 20.0) ?? UIFont()
                content.secondaryTextProperties.color = .lightGray
                content.secondaryTextProperties.alignment = .center
                content.text = "8 Sleep Hours"
                content.secondaryText = "March 24, 2024"
            } else {
                cell.selectionStyle = .default
                cell.backgroundColor = .purple
                content.textProperties.font = UIFont(name: "HelveticaNeue", size: 18.0) ?? UIFont()
                content.textProperties.color = .yellow
                content.textProperties.color = .white
                content.text = "See my stadistics"
            }
            cell.contentConfiguration = content
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.imageCell, for: indexPath) as! ImageTableViewCell
            cell.customizeCell(image: UIImage.sfSymbol("moon.fill", color: .yellow))
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.historyRecordCell, for: indexPath) as! HistoryRecordsTableViewCell
            cell.customizeCell(date: Date().formatted(), value: "100", time: "01:00 PM")
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.section == 1 ? self.safeAreaHeight * 0.65 : UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.scrollToRow(at: IndexPath(row: 0, section: 3), at: .top, animated: true)
    }
}
