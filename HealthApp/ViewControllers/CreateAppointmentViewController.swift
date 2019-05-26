import UIKit
import FirebaseAuth
import SCLAlertView
import EventKit

class CreateAppointmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var notes: String!
    var doctor: Doctor!
    var date: Date!
    var patient: Patient!
    var appointment: Appointment?
    var noteCell: NoteCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as! NameCell
            cell.nameLabel.text = doctor.username
            cell.profilePictureImageView.image = doctor.profilePicture
            cell.profilePictureImageView.setRounded()
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
            noteCell = cell
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PickerCell", for: indexPath) as! DatePickerCell
            date = cell.datePicker.date
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonSaveCell", for: indexPath) as! ButtonCell
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        var value: CGFloat = 0.0
        switch indexPath.row {
        case 0:
            value = 125.0
        case 1, 2:
            value = 260.0
        default:
            value = 65.0
        }
        
        return value
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            tableView.deselectRow(at: indexPath, animated: true)
            
            appointment = Appointment(startDate: date, endDate: date.addingTimeInterval(TimeInterval(60.0 * 60)), doctorUid: doctor.uid, patientUid: patient.uid)
            
            if !calendarIsBusy(appointment: appointment!, forPerson: doctor as AnyObject) {
                
                if !calendarIsBusy(appointment: appointment!, forPerson: patient as AnyObject) {
                    
                    doctor.add(appointment: appointment!)
                    patient.add(appointment: appointment!)
                    appointment?.notes = noteCell.textString
                    
                    if let errorMessage = appointment?.createInCalendar(doctor: doctor) {
                        let appearance = SCLAlertView.SCLAppearance( showCloseButton: false )
                        let alert = SCLAlertView(appearance: appearance)
                        alert.addButton("OK", action: {})
                        alert.showError(NSLocalizedString("appointment.create.errror", comment: ""), subTitle: errorMessage)
                    } else {
                        let appearance = SCLAlertView.SCLAppearance( showCloseButton: false )
                        let alert = SCLAlertView(appearance: appearance)
                        alert.addButton("OK", action: {})
                        alert.showSuccess(NSLocalizedString("appointment.create.sucess.title", comment: ""), subTitle: NSLocalizedString("appointment.create.sucess.message", comment: ""))
                        dismiss(animated: true, completion: nil)
                    }
                } else {
                    let appearance = SCLAlertView.SCLAppearance( showCloseButton: false )
                    let alert = SCLAlertView(appearance: appearance)
                    alert.addButton("OK", action: {})
                    alert.showNotice(NSLocalizedString("appointment.create.error.busy.title", comment: ""), subTitle: NSLocalizedString("appointment.create.error.busy.message", comment: ""))
                }
            } else {
                let appearance = SCLAlertView.SCLAppearance( showCloseButton: false )
                let alert = SCLAlertView(appearance: appearance)
                alert.addButton("OK", action: {})
                alert.showNotice(NSLocalizedString("appointment.create.error.busy.title", comment: ""), subTitle: NSLocalizedString("appointment.create.error.Doctorbusy.message" , comment: ""))
            }
        }
    }
    
    @IBAction func pickerView(_ sender: UIDatePicker) {
        date = sender.date
        var components = Calendar.current.dateComponents([.hour, .minute, .month, .year, .day], from: sender.date)
        
        if components.hour! < 7 {
            components.hour = 7
            components.minute = 0
            let appearance = SCLAlertView.SCLAppearance( showCloseButton: false )
            let alert = SCLAlertView(appearance: appearance)
            alert.addButton("OK", action: {})
            alert.showWarning(NSLocalizedString("appointment.create.timeError.title", comment: ""), subTitle: NSLocalizedString("appointment.create.earlyError.message", comment: ""))
            sender.setDate(Calendar.current.date(from: components)!, animated: true)
        } else if components.hour! > 21 {
            components.hour = 21
            components.minute = 59
            let appearance = SCLAlertView.SCLAppearance( showCloseButton: false )
            let alert = SCLAlertView(appearance: appearance)
            alert.addButton("OK", action: {})
            alert.showWarning(NSLocalizedString("appointment.create.lateError.title", comment: ""), subTitle: NSLocalizedString("appointment.create.timeError.message", comment: ""))
            sender.setDate(Calendar.current.date(from: components)!, animated: true)
        }
    }
    
    func calendarIsBusy(appointment: Appointment, forPerson: AnyObject) -> Bool {
        var isBusy = true
        
        if let patient = forPerson as? Patient {
            let patientAppointments = patient.appointments
            let results = patientAppointments.filter { $0.startDate == appointment.startDate }
            if results.count < 1 {
                isBusy = false
            }
        }
        
        if let doctor = forPerson as? Doctor {
            let doctorAppointments = doctor.appointments
            let results = doctorAppointments.filter { $0.startDate == appointment.startDate }
            if results.count < 1 {
                isBusy = false
                //isBusy = isDoctorBusy(doctor: doctor) ?? false
            }
        }
        return isBusy
    }
    
    /*func isDoctorBusy(doctor: Doctor) -> Bool? {
        var isBusy = false
        /*DatabaseService.shared.doctorsRef.child("\(doctor.uid)").child("profile").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let busy = value?["busy"] as? Bool ?? true
            isBusy = busy
            //print("El valor de la base de datos es: \(isBusy)")
            //group.leave()
        }) { (error) in
            print(error.localizedDescription)
        }
        //let group = DispatchGroup()
        //group.enter()
        //group.wait()
        //print("El valor final es: \(isBusy)")
        */
        return isBusy
    }*/
    
    /*func isDoctorBusy(doctor: Doctor) -> Bool {
        var isBusy = false
        DatabaseService.shared.doctorsRef.child("\(doctor.uid)").child("profile").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let busy = value?["busy"] as? Bool ?? true
            isBusy = busy
        }) { (error) in
            print(error.localizedDescription)
        }
        return isBusy
    }*/
    
    func eventExists(appointment: Appointment, eventStore: EKEventStore) -> EKEvent? {
        var event: EKEvent? = nil
        if let eventIdentifier = appointment.localIdentifier {
            event = eventStore.event(withIdentifier: eventIdentifier)
        }
        return event
    }
}
