//
//  DoctorProfileViewController.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 29/12/23.
//

import UIKit

class DoctorProfileViewController: UIViewController {
    
    var doctor: Doctor!
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Constants.Segues.showBookAppointmentVC,
           let destination = segue.destination as? BookAppointmentViewController else { return }
        destination.doctor = self.doctor
    }
}

extension DoctorProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.profileImageCell, for: indexPath) as! ProfileImageTableViewCell
            cell.customImageView.loadImageFrom(url: self.doctor.backgroundImage)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.buttonCell, for: indexPath) as! ButtonCellTableViewCell
            cell.button.isUserInteractionEnabled = false
            cell.button.setTitle("Book Appointment", for: .normal)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.basicCell, for: indexPath)
            if indexPath.row == 1 {
                var content = UIListContentConfiguration.cell()
                content.textProperties.font = UIFont(name: "HelveticaNeue-Medium", size: 20.0) ?? UIFont()
                content.textProperties.alignment = .natural
                content.text = self.doctor.fullName
                content.secondaryTextProperties.font = UIFont(name: "HelveticaNeue", size: 18.0) ?? UIFont()
                content.secondaryTextProperties.color = .secondaryLabel
                content.secondaryText = self.doctor.specialization
                cell.contentConfiguration = content
            } else if indexPath.row == 2 {
                var content = UIListContentConfiguration.cell()
                let baseString = self.doctor.description ?? .empty
                let fullRange = NSRange(location: 0, length: baseString.count)
                let attributedString = NSMutableAttributedString(string: baseString)
                attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: fullRange)
                attributedString.addAttribute(.foregroundColor, value: UIColor.secondaryLabel, range: fullRange)
                if let readMoreRange = baseString.range(of: "Read more") {
                    let nsRange = NSRange(readMoreRange, in: baseString)
                    attributedString.addAttribute(.foregroundColor, value: UIColor.systemRed, range: nsRange)
                }
                content.attributedText = attributedString
                cell.contentConfiguration = content
            } else {
                var content = UIListContentConfiguration.cell()
                cell.backgroundColor = .clear
                content.text = "Delete Doctor"
                content.textProperties.color = .red
                content.textProperties.alignment = .center
                cell.contentConfiguration = content
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            self.performSegue(withIdentifier: Constants.Segues.showBookAppointmentVC, sender: nil)
        } else if indexPath.row == 4 {
            guard let url = URL(string: "https://api.healthapp.local/doctor") else { return }
            Task {
                let response = await RequestManager.shared.request(url: url, method: .delete, body: [
                    "userId": 0,
                    "doctorId": self.doctor.id
                ])
                
                guard response.httpStatusCode == .success else {
                    self.showFloatingAlert(text: "Error at deleting", alertType: .error)
                    return
                }
                
                self.showFloatingAlert(text: "Doctor deleted", alertType: .success)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.row == 0 ? self.view.frame.size.height * 0.60 : UITableView.automaticDimension
    }
}
