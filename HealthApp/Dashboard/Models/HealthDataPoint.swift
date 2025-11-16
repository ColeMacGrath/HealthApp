//
//  HealthDataPoint.swift
//  HealthApp
//
//  Created by Moises Cordova on 11/15/2025.
//

import Foundation

struct HealthDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
