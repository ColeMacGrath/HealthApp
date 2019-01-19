import UIKit

class DoctorsTableViewController: UITableViewController {
    
    var doctors: [Doctor] = []
    var patient: Patient!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = UIColor.gray
        refreshControl?.backgroundColor = UIColor.white
        refreshControl?.attributedTitle = NSAttributedString(string: " ↓ \(NSLocalizedString("table.refresh.message", comment: "")) ↓ ")
        refreshControl?.addTarget(self, action: #selector(DoctorsTableViewController.getDoctors), for: .valueChanged)
        
        getDoctors()
    }
    
    @objc func getDoctors() {        
        doctors = []
        DatabaseService.shared.usersRef.child(patient.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let doctorsUid = value?["doctors"] as? NSDictionary ?? [:]
            for doctor in doctorsUid {
                DatabaseService.shared.doctorsRef.child("\(doctor.key)").child("profile").observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let firstName = value?["firstName"] as? String ?? ""
                    let lastName = value?["lastName"] as? String ?? ""
                    let address = value?["direction"] as? String ?? ""
                    let email = value?["email"] as? String ?? ""
                    let phone = value?["phone"] as? String ?? ""
                    let specialty = value?["speciality"] as? String ?? NSLocalizedString("doctor.general", comment: "")
                    let newDoctor = Doctor(uid: "\(doctor.key)", firstName: firstName, lastName: lastName, direction: address, email: email, phone: phone, specialty: specialty, profilePicture: UIImage(named: "Doctor-Profile1")!)
                    if self.doctors.count >= 1 {
                        newDoctor.profilePicture = UIImage(named: "Doctor-Profile2")!
                    }
                    self.doctors.append(newDoctor)
                    self.refreshControl?.endRefreshing()
                    self.spinner.stopAnimating()
                    self.tableView.reloadData()
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
            self.refreshControl?.endRefreshing()
            self.spinner.stopAnimating()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.doctors.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let doctor = doctors[indexPath.row]
        let cellID = "DoctorCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! DoctorCell
        
        cell.profileImage.image = doctor.profilePicture
        cell.profileImage.setRounded()
        cell.nameLabel.text = doctor.username
        cell.phoneLabel.text = doctor.phone
        cell.directionLabel.text = doctor.direction
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.doctors.remove(at: indexPath.row)
        }
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: NSLocalizedString("doctorTable.delete", comment: "")) { (action, indexPath) in
            let doctorToRemove = self.doctors[indexPath.row]
            DatabaseService.shared.usersRef.child(self.patient.uid).child("doctors").child(doctorToRemove.uid).removeValue()
            DatabaseService.shared.doctorsRef.child(doctorToRemove.uid).child("patients").child(self.patient.uid).removeValue()
            
            self.doctors.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        deleteAction.backgroundColor = UIColor.red
        
        return [deleteAction]
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: NSLocalizedString("doctorTable.add", comment: ""), message: NSLocalizedString("doctorTable.add.message", comment: ""), preferredStyle: .actionSheet)
        let scanAction = UIAlertAction(title: NSLocalizedString("doctorTable.add.scan", comment: ""), style: .default) { (action) in
            self.performSegue(withIdentifier: "showQRAnalyzerVC", sender: nil)
        }
        alertController.addAction(scanAction)
        
        let createQRAction = UIAlertAction(title: NSLocalizedString("doctorTable.add.show", comment: ""), style: .default) { (action) in
            self.performSegue(withIdentifier: "showQRVC", sender: nil)
        }
        alertController.addAction(createQRAction)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("doctor.contact.cancel", comment: ""), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDoctorProfile" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedDoctor = self.doctors[indexPath.row]
                let destinationViewController = segue.destination as! DoctorProfileViewController
                destinationViewController.doctor = selectedDoctor
                destinationViewController.patient = patient
            }
        }
    }
    
}
