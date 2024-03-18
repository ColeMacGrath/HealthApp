//
//  Patient.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-03-17.
//

import Foundation

struct CaloriesBurned: Codable {
    let date: Date
    let calories: Int
}

struct HeartRate: Codable {
    let BPM: Int
    let date: Date
}

struct Weight: Codable {
    let date: Date
    let kilograms: Int
}

struct IngestedFood: Codable {
    let date: Date
    let foodName: String
    let calories: Int
}

struct Sleep: Codable {
    let endDate: Date
    let startDate: Date
}

struct HealthDataStructure: Codable {
    let caloriesBurned: [CaloriesBurned]
    let hearthBPM: [HeartRate]
    let weight: [Weight]
    let ingestedFood: [IngestedFood]
    let sleep: [Sleep]
}

struct Patient: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let healthData: HealthDataStructure?
    let profilePicture: URL?
    let age: Int
    let weight: Int
    let height: Int
    let biologicalSex: String
    
    var fullName: String {
        "\(self.firstName) \(self.lastName)"
    }
    
    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, healthData, profilePicture, age, weight, height, biologicalSex
    }
}
