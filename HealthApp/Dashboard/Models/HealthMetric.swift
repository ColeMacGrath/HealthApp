//
//  HealthMetric.swift
//  HealthApp
//
//  Created by Moises Cordova on 11/15/2025.
//

import SwiftUI

struct HealthMetric {
    let title: String
    let icon: String
    let color: Color
    let currentValue: String
    let subtitle: String?
    let data: [HealthDataPoint]
}
