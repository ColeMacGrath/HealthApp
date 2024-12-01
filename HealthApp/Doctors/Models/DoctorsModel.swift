//
//  DoctorsModel.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-12-01.
//

import Foundation

@Observable
@MainActor
class DoctorsModel {
    var doctors: [Doctor] = []
    
    func fectchDoctors() async {
        let response = await NetworkManager.shared.doctorList()
        guard response.statusCode == .ok,
              let doctors = response.doctors else { return }
        self.doctors = doctors
    }
}
