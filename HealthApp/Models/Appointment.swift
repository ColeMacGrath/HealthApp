//
//  Appointment.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-02-11.
//

import Foundation

struct Appointment: Codable {
    let id: Int
    let doctor: Doctor
    let date: Date
    let notes: String
}

struct AppointmentsContainer: Codable {
    let appointments: [Appointment]
}
