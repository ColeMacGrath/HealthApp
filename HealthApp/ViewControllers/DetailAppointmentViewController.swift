import UIKit
import SCLAlertView

class DetailAppointmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var appointment: Appointment!
    var doctor: Doctor!
    var patient: Patient!
    
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailedNameCell", for: indexPath) as! DetailedNameCell
            cell.nameLabel.text = doctor.username
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! DateCell
            cell.monthLabel.text = appointment.duration
            cell.durationLabel.text = "\(appointment.startDate.formattedHour) - \(appointment.endDate.formattedHour)"
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
            cell.noteTextView.text = appointment.notes
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeleteButtonCell", for: indexPath) as! ButtonCell
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
            
            let appearance = SCLAlertView.SCLAppearance( showCloseButton: false )
            let alert = SCLAlertView(appearance: appearance)
            alert.addButton(NSLocalizedString("cancel.message", comment: ""), action: {})
            alert.addButton(NSLocalizedString("delete.confirmation", comment: "")) {
                if self.appointment!.removeFromLocalCalendar() {
                    self.appointment.removeFromServer()
                    let appearance = SCLAlertView.SCLAppearance( showCloseButton: false )
                    let alert = SCLAlertView(appearance: appearance)
                    alert.addButton("OK", action: {})
                    alert.showWarning(NSLocalizedString("appointment.deleted.title", comment: ""), subTitle: NSLocalizedString("appointment.deleted.message", comment: ""))
                    self.dismiss(animated: true, completion: nil)
                } else {
                    let appearance = SCLAlertView.SCLAppearance( showCloseButton: false )
                    let alert = SCLAlertView(appearance: appearance)
                    alert.addButton("OK", action: {})
                    alert.showError(NSLocalizedString("appointment.delete.error.title", comment: ""), subTitle: NSLocalizedString("appointment.delete.error.message", comment: ""))
                }
            }
            alert.showWarning(NSLocalizedString("appointment.delete.title", comment: ""), subTitle: NSLocalizedString("appointment.delete.message", comment: ""))
        }
    }
}
