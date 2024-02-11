//
//  AppointmentsViewController.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 29/12/23.
//

import UIKit

class AppointmentsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var selectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @objc private func datePickerChanged(_ sender: UIDatePicker) {
        self.selectedDate = sender.date
        self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
    }
    
    
}

extension AppointmentsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section == 0 else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.appointmentCell, for: indexPath) as! AppointmentTableViewCell
            cell.separatorInset.addSeparator()
            cell.customizeCell(name: "Juan Gabriel Gomila Salas", date: "Mach 26, 2023", image: UIImage(named: "doctor"))
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.datePickerCell, for: indexPath) as! DatePickerTableViewCell
        cell.datePicker.date = self.selectedDate
        cell.datePicker.addTarget(self, action: #selector(self.datePickerChanged(_:)), for: .valueChanged)
        cell.updateDate()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: Constants.Segues.showAppointmentVC, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? self.selectedDate.dayOfWeek.uppercased() : "Upcoming Appointments"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 0 ? 50.0 : 20.0
    }
}
