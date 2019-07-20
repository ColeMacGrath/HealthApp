//
//  ViewController.swift
//  TestingCalendar
//
//  Created by Moisés Córdova on 6/17/19.
//  Copyright © 2019 Moisés Córdova. All rights reserved.
//

import UIKit
import RealmSwift
import JTAppleCalendar

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var calendarView: JTACMonthView!
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    var patient: Patient?
    let realm = try? Realm()
    var appointmentsOfDate = [Appointment]()
    var doctorsForDate = [Doctor]()
    var selectedAppointment: Appointment!
    var selectedDoctor: Doctor!
    
    //calendar color
    let outsideMonthColor = UIColor.lightGray
    let monthColor = UIColor.darkGray
    let selectedMonthColor = UIColor.white
    let currentDateSelectedViewColor = UIColor.black
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = refreshControl
        refreshControl.tintColor = UIColor.darkGray
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching User Data ...", attributes: nil)
        refreshControl.addTarget(self, action: #selector(checkInCloudAppointments), for: .valueChanged)
        
        if let firstViewController = self.tabBarController?.viewControllers?.first as? ProfileViewController {
            self.patient = firstViewController.patient
            appointmentsOfDate = getAppointmentsFor(date: calendarView.selectedDates.last ?? Date())
            checkInCloudAppointments()
        }
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()   
        
        calendarView.selectDates([Date()])
        calendarView.scrollToDate(Date(), animateScroll: true)
        
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
    }
    
    func getAppointmentsFor(date: Date) -> [Appointment] {
        let events = patient?.appointments.filter({ return $0.startDate.shortDate == date.shortDate })
        return events?.sorted(by: { $0.startDate < $1.startDate }) ?? []
    }
    
    @objc func checkInCloudAppointments() {
        var uids = [String]()
        guard let patientUID = patient?.uid else { return }
        DatabaseService.shared.patientsRef.child(patientUID).child("appointments").observeSingleEvent(of: .value) { (snapshot) in
            if let appointmentsUID = snapshot.value as? Dictionary<String, AnyObject> {
                for appointmentUID in appointmentsUID {
                    uids.append(appointmentUID.key)
                }
            }
            
            DispatchQueue.main.async {
                self.downloadAppointments(uids: uids)
            }
        }
    }
    
    func downloadAppointments(uids: [String]) {
        for uid in uids {
            DatabaseService.shared.appointmentsRef.child(uid).observeSingleEvent(of: .value) { (snapshot) in
                if let appointmentDict = snapshot.value as? Dictionary<String, AnyObject> {
                    if let doctorUID = appointmentDict["doctorUID"] as? String,
                    let startDate = appointmentDict["startDate"] as? String,
                    let endDate = appointmentDict["endDate"] as? String
                    {
                        if let myStartDate = startDate.createDate,
                            let myEndDate = endDate.createDate {
                            let notes = appointmentDict["notes"] as? String
                            DispatchQueue.main.async {
                                if self.realm?.object(ofType: Appointment.self, forPrimaryKey: uid) == nil {
                                    let appointment = Appointment(startDate: myStartDate, endDate: myEndDate, doctorUid: doctorUID, patientUid: self.patient!.uid, notes: notes)
                                    do {
                                        try self.realm?.write {
                                            self.patient?.appointments.append(appointment)
                                        }
                                    } catch {
                                        print("Error writting locally: \(error.localizedDescription)")
                                    }
                                    
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
        appointmentsOfDate = getAppointmentsFor(date: calendarView.selectedDates.last ?? Date())
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCreateAppointmentVC" {
            if let pageViewController = segue.destination as? CreateAppointmentViewController {
                pageViewController.selectedDate = self.calendarView.selectedDates.last
            }
        } else if segue.identifier == "showAppointmentVC" {
            if let viewController = segue.destination as? AppointmentViewController {
                viewController.appointment = self.selectedAppointment
                viewController.doctor = self.selectedDoctor
            }
        }
    }
    
}

extension CalendarViewController: JTACMonthViewDataSource {
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        var parameters: ConfigurationParameters
        var startDate = Date()
        var endDate = Date()
        if let calendarStartDate = formatter.date(from: "2017 01 01"),
            let calendarEndndDate = formatter.date(from: "2017 12 31") {
            startDate = calendarStartDate
            endDate = calendarEndndDate
        }
        startDate = Date()
        endDate = Date()
        parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 1)
        return parameters
    }
}

extension CalendarViewController: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarDayCell", for: indexPath) as! CalendarDayCell
        cell.dateLabel.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarDayCell", for: indexPath) as! CalendarDayCell
        cell.dateLabel.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        appointmentsOfDate = getAppointmentsFor(date: date)
        tableView.reloadData()
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsFromCalendar(from: visibleDates)
    }
}

extension CalendarViewController {
    func handleCellSelected(view: JTACDayCell?, cellState: CellState) {
        guard let validCell = view as? CalendarDayCell else { return }
        if cellState.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
    }
    
    func handleCellTextColor(view: JTACDayCell?, cellState: CellState) {
        guard let validCell = view as? CalendarDayCell else {
            return
        }
        
        let todaysDate = Date()
        if todaysDate.day == cellState.date.day {
            validCell.dateLabel.textColor = UIColor.purple
        } else {
            validCell.dateLabel.textColor = cellState.isSelected ? UIColor.purple : UIColor.darkGray
        }
        
        
        if cellState.isSelected {
            validCell.dateLabel.textColor = selectedMonthColor
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
            } else {
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
    }
    
    func setupCalendarView() {
        // Setup Calendar Spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
    }
    
    func setupViewsFromCalendar(from visibleDates: DateSegmentInfo ) {
        guard let date = visibleDates.monthDates.first?.date else { return }
        
        formatter.dateFormat = "MMMM"
        title = formatter.string(from: date).uppercased()
    }
    
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointmentsOfDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dateRecipeCell", for: indexPath) as! AppointmentTableViewCell
        let doctorUID = appointmentsOfDate[indexPath.row].doctorUid
        if let doctor = self.realm?.object(ofType: Doctor.self, forPrimaryKey: doctorUID) {
            cell.doctorNameLabel.text = "\(doctor.firstName) \(doctor.lastName)"
            doctorsForDate.append(doctor)
        }
        
        cell.hourLabel.text = appointmentsOfDate[indexPath.row].startDate.hourAndMinutes
        cell.appointmentTitleLabel.text = "Appointment"
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAppointment = appointmentsOfDate[indexPath.row]
        selectedDoctor = doctorsForDate[indexPath.row]
        performSegue(withIdentifier: "showAppointmentVC", sender: nil)
    }
}
