//
//  Doctor.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-11-03.
//

import Foundation
import SwiftUI

struct Doctor: Codable, Identifiable, Hashable {
    let id: Int
    let firstName: String
    let lastName: String
    let specialization: String?
    let description: String?
    let profilePicture: URL?
    let lightBackgroundColor: Color?
    let darkBackgroundColor: Color?
    let schedules: [Schedule]
    let patients: [Int]?
    
    var fullName: String { "\(firstName) \(lastName)" }
    
    private enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, specialization, description, profilePicture, lightBackgroundColor, darkBackgroundColor, schedules, patients
    }
    
    // Custom decoding for Color
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        specialization = try container.decodeIfPresent(String.self, forKey: .specialization)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        profilePicture = try container.decodeIfPresent(URL.self, forKey: .profilePicture)
        schedules = try container.decode([Schedule].self, forKey: .schedules)
        patients = try container.decodeIfPresent([Int].self, forKey: .patients)
        
        // Decode Colors
        if let lightColorValues = try container.decodeIfPresent(ColorValues.self, forKey: .lightBackgroundColor) {
            lightBackgroundColor = Color(red: lightColorValues.red, green: lightColorValues.green, blue: lightColorValues.blue)
        } else {
            lightBackgroundColor = nil
        }
        
        if let darkColorValues = try container.decodeIfPresent(ColorValues.self, forKey: .darkBackgroundColor) {
            darkBackgroundColor = Color(red: darkColorValues.red, green: darkColorValues.green, blue: darkColorValues.blue)
        } else {
            darkBackgroundColor = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encodeIfPresent(specialization, forKey: .specialization)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(profilePicture, forKey: .profilePicture)
        try container.encode(schedules, forKey: .schedules)
        try container.encodeIfPresent(patients, forKey: .patients)
        
        if let lightColor = lightBackgroundColor {
            let components = lightColor.getRGBComponents()
            try container.encode(ColorValues(red: components.red, green: components.green, blue: components.blue), forKey: .lightBackgroundColor)
        }
        
        if let darkColor = darkBackgroundColor {
            let components = darkColor.getRGBComponents()
            try container.encode(ColorValues(red: components.red, green: components.green, blue: components.blue), forKey: .darkBackgroundColor)
        }
    }
}

extension Color {
    func getRGBComponents() -> (red: Double, green: Double, blue: Double) {
        let components = UIColor(self).cgColor.components ?? [0, 0, 0]
        return (red: Double(components[0]), green: Double(components[1]), blue: Double(components[2]))
    }
}

struct ColorValues: Codable {
    let red: Double
    let green: Double
    let blue: Double
}

struct Schedule: Codable, Hashable {
    let day: String
    let times: [String]
}
