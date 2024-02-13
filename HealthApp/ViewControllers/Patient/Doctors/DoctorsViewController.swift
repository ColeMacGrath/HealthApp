//
//  DoctorsViewController.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 28/12/23.
//

import UIKit
import SwiftUI

class DoctorsViewController: UIViewController {
    
    @IBOutlet weak var doctorsCollectionView: UICollectionView!
    var doctors: [Doctor] = []
    var selectedDoctor: Doctor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let url = URL(string: RequestManager.shared.baseURL + "0/" + "doctors") else {
            self.showFloatingAlert(text: "Error loading doctors", alertType: .error)
            return
        }
        Task {
            
            guard let responseData = await RequestManager.shared.request(url: url, method: .get).rawData else {
                self.showFloatingAlert(text: "Error loading doctors", alertType: .error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let doctors = try decoder.decode([String: [Doctor]].self, from: responseData)["doctors"] ?? []
                self.doctors = doctors
                self.doctorsCollectionView.reloadData()
                
            } catch {
                self.showFloatingAlert(text: "Error loading doctors", alertType: .error)
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Constants.Segues.showDoctorProfileVC,
        let destination = segue.destination as? DoctorProfileViewController,
        let selectedDoctor else { return }
        
        destination.doctor = selectedDoctor
    }
    
    @IBAction func addDoctorButtonPressed(_ sender: UIBarButtonItem) {
        let hostingController = UIHostingController(rootView: QRView())
        self.navigationController?.pushViewController(hostingController, animated: true)
    }
    
}

extension DoctorsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.doctors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.doctorCell, for: indexPath) as! DoctorCollectionViewCell
        cell.cutomizeCell(doctor: self.doctors[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedDoctor = self.doctors[indexPath.row]
        self.performSegue(withIdentifier: Constants.Segues.showDoctorProfileVC, sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.size.height
        let width = view.safeAreaLayoutGuide.layoutFrame.size.width
        
        let device = UIDevice.current
        
        if device.userInterfaceIdiom == .phone { //If device is an iPhone
            //if device.orientation.isLandscape { //If device is Landscaoe
            //  return CGSize(width: width * 0.45, height: height * 0.4)
            //}
            
            if indexPath.section == 0 {
                return CGSize(width: width * 0.45, height: height * 0.30)
            }
            
            return CGSize(width: width * 0.40, height: height * 0.30)
        }
        return CGSize(width: width * 0.48, height: height * 0.35) //If device is iPad
    }
}
