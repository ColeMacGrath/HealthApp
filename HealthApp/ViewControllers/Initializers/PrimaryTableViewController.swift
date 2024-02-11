//
//  PrimaryTableViewController.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 28/12/23.
//

import UIKit

enum RowOption: Int {
    case me
    case doctors
    case appointments
}

struct PrimaryRow {
    let title: String
    let icon: UIImage
    let rowOption: RowOption
}

class PrimaryTableViewController: UITableViewController {
    
    let items = [
        PrimaryRow(title: "Me", icon: UIImage.sfSymbol(Constants.SFSymbols.personFill, color: .red), rowOption: .me),
        PrimaryRow(title: "Doctors", icon: UIImage.sfSymbol(Constants.SFSymbols.heartFill, color: .red), rowOption: .doctors),
        PrimaryRow(title: "Appointments", icon: UIImage.sfSymbol(Constants.SFSymbols.calendar, color: .red), rowOption: .appointments)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "HealthApp"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        guard let splitViewController  else { return }
        
        self.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
        splitViewController.setViewController(nil, for: .supplementary)
        splitViewController.setViewController(UIStoryboard(name: Constants.Storyboard.dashboard, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewIdentifiers.dashboardNavigationController), for: .secondary)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.labelIconCell, for: indexPath) as! IconLabelTableViewCell
        let item = items[indexPath.row]
        cell.configure(title: item.title, icon: item.icon)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let splitViewController else { return }
        
        switch items[indexPath.row].rowOption {
        case .me:
            splitViewController.setViewController(nil, for: .supplementary)
            splitViewController.setViewController(UIStoryboard(name: Constants.Storyboard.dashboard, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewIdentifiers.dashboardNavigationController), for: .secondary)
        case .doctors:
            splitViewController.setViewController(UIStoryboard(name: Constants.Storyboard.doctors, bundle: nil).instantiateViewController(withIdentifier: "DoctorsVC"), for: .supplementary)
            splitViewController.setViewController(UIStoryboard(name: Constants.Storyboard.doctors, bundle: nil).instantiateViewController(withIdentifier: "DoctorVC"), for: .secondary)
        case .appointments:
            splitViewController.setViewController(nil, for: .supplementary)
            splitViewController.setViewController(UIStoryboard(name: Constants.Storyboard.appointments, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewIdentifiers.appointmentsNC), for: .secondary)
        }
        
    }
}
