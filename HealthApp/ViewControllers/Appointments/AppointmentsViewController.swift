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
    var selectedAppointment: Appointment?
    var appointments: [Appointment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadAppointmnets()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Constants.Segues.showAppointmentVC,
              let destination = segue.destination as? AppointmentViewController,
            let selectedAppointment  else { return }
        destination.appointment = selectedAppointment
    }
    
    private func loadAppointmnets() {
        guard let url = URL(string: RequestManager.shared.baseURL + "UserId/" + "appointments") else {
            self.showFloatingAlert(text: "Error loading appointments", alertType: .error)
            return
        }
        Task {
            
            guard let responseData = await RequestManager.shared.request(url: url, method: .get).rawData else {
                self.showFloatingAlert(text: "Error loading appointments", alertType: .error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .customISO8601
                let appointmentsContainer = try decoder.decode(AppointmentsContainer.self, from: responseData)
                self.appointments = appointmentsContainer.appointments.filter({ $0.date.isOnSameDayThan(date: self.selectedDate) })
            } catch {
                self.appointments.removeAll()
                self.showFloatingAlert(text: "Error loading appointments", alertType: .error)
            }
            self.tableView.reloadData()
        }
    }
    
    @objc private func datePickerChanged(_ sender: UIDatePicker) {
        self.selectedDate = sender.date
        self.loadAppointmnets()
    }
    
}

extension AppointmentsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : self.appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section == 0 else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.appointmentCell, for: indexPath) as! AppointmentTableViewCell
            cell.separatorInset.addSeparator()
            cell.customizeCell(appointment: self.appointments[indexPath.row])
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
        self.selectedAppointment = self.appointments[indexPath.row]
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
