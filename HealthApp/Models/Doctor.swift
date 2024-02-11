//
//  Doctor.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-02-10.
//

import Foundation

struct Doctor: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let profilePicture: URL?
    let bkacgroundImage: URL?
    let description: String?
    let specialization: String
    let schedules: [Schedule]
    
    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, profilePicture, bkacgroundImage, description, specialization, schedules
    }
}

struct Schedule: Codable {
    let day: String
    let times: [String]
}
