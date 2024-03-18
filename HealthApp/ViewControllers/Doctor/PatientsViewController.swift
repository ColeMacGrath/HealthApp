//
//  PatientsViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-02-13.
//

import UIKit

class PatientsViewController: UIViewController {
    
    @IBOutlet weak var patientsTableView: UITableView!
    private var patients: [Patient] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label]
        self.loadPatients()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
    }
    
    func loadPatients() {
        Task {
            guard let url = RequestManager.shared.getURLWithDoctorFor(endpoint: .patients),
                let responseData = await RequestManager.shared.request(url: url, method: .get).rawData else {
                self.showFloatingAlert(text: "Error loading patients", alertType: .error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                let patients = try decoder.decode([String: [Patient]].self, from: responseData)["patients"] ?? []

                self.patients = patients
                self.patientsTableView.reloadData()
                
            } catch {
                print(error)
                self.showFloatingAlert(text: "Error loading patients", alertType: .error)
            }
            
        }
    }
    
}

extension PatientsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.patients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.dataTableViewCell, for: indexPath) as! DataTableViewCell
        let patient = self.patients[indexPath.row]
        cell.customizeCell(title: patient.fullName, value: "\(patient.biologicalSex)\n\(patient.age) y/o", imageURL: patient.profilePicture, roundedImage: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
