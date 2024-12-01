//
//  HealthData.swift
//  HealthAppUI
//
//  Created by Moisés Córdova on 2024-11-03.
//

import Foundation

struct HealthData: Identifiable, Equatable {
    let id = UUID()
    let startDate: Date?
    let endDate: Date?
    let value: Double?
}
