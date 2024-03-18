//
//  Doctor.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-02-10.
//

import Foundation

struct Doctor: Codable {
    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, profilePicture, backgroundImage, description, specialization, schedules
    }
    let id: Int
    let firstName: String
    let lastName: String
    let profilePicture: URL?
    let backgroundImage: URL?
    let description: String?
    let specialization: String
    let schedules: [Schedule]?
    
    var fullName: String {
        "\(self.firstName) \(self.lastName)"
    }
}
