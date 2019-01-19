import UIKit
import MessageUI

enum optionSelected: Int {
    case phone = 0
    case mail = 1
    case address = 2
    case appointment = 3
}

class DoctorProfileViewController: UIViewController {
    var doctor: Doctor!
    var patient: Patient!
    
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var specialityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInformation()
    }
    
    func setInformation() {
        phoneLabel.text = doctor.phone
        mailLabel.text = doctor.email
        addressLabel.text = doctor.direction
        profilePictureImageView.image = doctor.profilePicture
        profilePictureImageView.setRounded()
        nameLabel.text = doctor.username
        specialityLabel.text = doctor.specialty
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        /*case phone = 0
        case mail = 1
        case address = 2
        case appointment = 3*/
        switch sender.tag {
        case 0:
            let alertController = UIAlertController(title: "\(NSLocalizedString("doctor.contact.title", comment: "")) \(doctor.username)", message: "\(NSLocalizedString("doctor.contact.title", comment: "")) \(doctor.phone)", preferredStyle: .actionSheet)
            let callAction = UIAlertAction(title: NSLocalizedString("doctor.contact.call", comment: ""), style: .default) { (action) in
                if let phoneURL = URL(string: "tel://\(self.doctor.phone)") {
                    let app = UIApplication.shared
                    if app.canOpenURL(phoneURL) {
                        app.open(phoneURL, options: [:], completionHandler: nil)
                    }
                }
            }
            alertController.addAction(callAction)
            
            let messageAction = UIAlertAction(title: NSLocalizedString("doctor.contact.message.send", comment: ""), style: .default) { (action) in
                if MFMessageComposeViewController.canSendText() {
                    let messageVC = MFMessageComposeViewController()
                    messageVC.recipients = [self.doctor.phone]
                    messageVC.messageComposeDelegate = self
                    self.present(messageVC, animated: true, completion: nil)
                }
            }
            alertController.addAction(messageAction)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("doctor.contact.cancel", comment: ""), style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        case 1:
            if MFMailComposeViewController.canSendMail() {
                let mailComposeViewController = MFMailComposeViewController()
                mailComposeViewController.setToRecipients([doctor.email])
                mailComposeViewController.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
                present(mailComposeViewController, animated: true, completion: nil)
            }
        case 2:
            performSegue(withIdentifier: "showMap", sender: nil)
        case 3:
            performSegue(withIdentifier: "showAppoitmentsVC", sender: nil)
        default:
            break
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            let destionationViewController = segue.destination as! MapViewController
            destionationViewController.doctor = doctor
        } else if segue.identifier == "showAppoitmentsVC" {
            let destinationViewController = segue.destination as! AppointmentsViewController
            destinationViewController.patient = patient
            destinationViewController.doctor = doctor
        }
    }
    
}

extension DoctorProfileViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
        print(result)
    }
}

extension DoctorsTableViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
        print(result)
    }
}
