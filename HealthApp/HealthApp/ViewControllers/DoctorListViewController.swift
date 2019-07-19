//
//  DoctorListViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 7/6/19.
//  Copyright © 2019 Moisés Córdova. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseStorage

class DoctorListViewController: UIViewController {
    
    private let refreshControl = UIRefreshControl()
    var buttonImages: [UIImage] = [#imageLiteral(resourceName: "blue_button"), #imageLiteral(resourceName: "pink_button"), #imageLiteral(resourceName: "green_button"), #imageLiteral(resourceName: "blue_button"), #imageLiteral(resourceName: "aqua_button")]
    var patient: Patient?
    var selectedDoctor: Doctor!
    let realm = try? Realm()
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = refreshControl
        refreshControl.tintColor = UIColor.black
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching My Doctors ...", attributes: nil)
        refreshControl.addTarget(self, action: #selector(getDoctorsUID), for: .valueChanged)
        if let firstViewController = self.tabBarController?.viewControllers?.first as? ProfileViewController {
            self.patient = firstViewController.patient
        }
        
        getDoctorsUID()
    }
    
    @objc func getDoctorsUID() {
        guard let patientUID = patient?.uid else { return }
        
        var uids = [String]()
        DatabaseService.shared.patientsRef.child(patientUID).child("doctors").observeSingleEvent(of: .value) { (snapshot) in
            if let doctorsUID = snapshot.value as? Dictionary<String, AnyObject> {
                for doctorUID in doctorsUID {
                    uids.append(doctorUID.key)
                }
            }
            
            DispatchQueue.main.async {
                self.downloadDoctors(uids: uids)
            }
        }
    }
    
    func downloadDoctors(uids: [String]) {
        for uid in uids {
            DatabaseService.shared.doctorsRef.child(uid).observeSingleEvent(of: .value) { (snapshot) in
                if let doctorDict = snapshot.value as? Dictionary<String, AnyObject> {
                    if let firstName = doctorDict["firstName"] as? String,
                        let lastName = doctorDict["lastName"] as? String,
                        let address = doctorDict["address"] as? String,
                        let phone = doctorDict["phone"] as? String,
                        let email = doctorDict["email"] as? String,
                        let specialty = doctorDict["specialty"] as? String
                    {
                        DispatchQueue.main.async {
                            if let localDoctor = self.realm?.object(ofType: Doctor.self, forPrimaryKey: uid) {
                                self.downloadDoctorProfileImage(doctorDict: doctorDict, doctor: localDoctor)
                                do {
                                    try? self.realm?.write {
                                        if localDoctor.firstName != firstName {
                                            localDoctor.firstName = firstName
                                        }
                                        if localDoctor.lastName != lastName {
                                            localDoctor.lastName = lastName
                                        }
                                        if localDoctor.direction != address {
                                            localDoctor.direction = address
                                        }
                                        if localDoctor.phone != phone {
                                            localDoctor.phone = phone
                                        }
                                        if localDoctor.email != email {
                                            localDoctor.email = email
                                        }
                                        if localDoctor.specialty != specialty {
                                            localDoctor.specialty = specialty
                                        }
                                    }
                                }
                            } else {
                                 let doctor = Doctor(uid: uid, firstName: firstName, lastName: lastName, direction: address, email: email, phone: phone, specialty: specialty, profilePicture: nil)
                                self.downloadDoctorProfileImage(doctorDict: doctorDict, doctor: doctor)
                                do {
                                    try? self.realm?.write {
                                        self.patient?.doctors.append(doctor)
                                    }
                                }
                            }
                            self.tableView.reloadData()
                            self.refreshControl.endRefreshing()
                        }
                    }
                }
            }
        }
    }
    
    func downloadDoctorProfileImage(doctorDict: Dictionary<String, AnyObject>, doctor: Doctor) {
        if let profilePictureURL = doctorDict["profilePicture"] as? Dictionary<String, AnyObject> {
            if let imageURL = profilePictureURL["profilePictureURL"] as? String {
                let httpRef = Storage.storage().reference(forURL: imageURL)
                httpRef.getData(maxSize: 15*1024*1024, completion: { (data, error) in
                    if error != nil {
                        print("Error al descargar la imagen: \(String(describing: error?.localizedDescription))")
                    } else {
                        do {
                            try self.realm?.write {
                                doctor.dataProfileImage = data
                            }
                        } catch {
                            print("No se pudo poner la imagen")
                        }
                        
                    }
                })
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDoctorProfileVC" {
            if let viewController = segue.destination as? DoctorProfileViewController {
                viewController.doctor = self.selectedDoctor
            }
        }
    }
    
}

extension DoctorListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patient?.doctors.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactTableViewCell
        guard let cellDoctor = patient?.doctors[indexPath.row] else { return cell }
        cell.profileImageView.image = cellDoctor.profilePicture ?? UIImage(named: "profile-placeholder")
        cell.nameLabel.text = "\(cellDoctor.firstName) \(cellDoctor.lastName)"
        cell.specialistButton.setTitle(cellDoctor.specialty, for: .normal)
        cell.specialistButton.setBackgroundImage(buttonImages[0], for: .normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDoctor = patient?.doctors.randomElement()
        performSegue(withIdentifier: "showDoctorProfileVC", sender: nil)
    }
}
