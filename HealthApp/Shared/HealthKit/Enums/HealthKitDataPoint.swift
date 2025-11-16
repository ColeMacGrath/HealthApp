//
//  HealthKitDataPoint.swift
//  HealthApp
//
//  Created by Moises Cordova on 11/15/2025.
//

import Foundation

struct HealthKitDataPoint: Sendable {
    let startDate: Date
    let endDate: Date
    let value: Double
    
    func formattedValue(for type: HealthDataType) -> String {
        switch type {
        case .steps:
            return String(format: "%.0f", value)
        case .activeCalories, .basalCalories, .dietaryEnergy:
            return String(format: "%.0f kcal", value)
        case .sleep:
            let hours = Int(value)
            let minutes = Int((value - Double(hours)) * 60)
            return "\(hours)h \(minutes)m"
        case .heartRate:
            return String(format: "%.0f bpm", value)
        case .weight:
            return String(format: "%.1f kg", value)
        case .height:
            return String(format: "%.2f m", value)
        case .protein, .carbohydrates, .totalFat, .fiber, .sugar:
            return String(format: "%.1f g", value)
        case .sodium, .potassium, .calcium, .iron, .zinc, .magnesium, .phosphorus,
             .vitaminB6, .vitaminC, .vitaminE, .cholesterol, .caffeine:
            return String(format: "%.1f mg", value)
        case .vitaminA, .vitaminB12, .vitaminD, .vitaminK, .folate:
            return String(format: "%.1f μg", value)
        case .water:
            return String(format: "%.0f ml", value)
        default:
            return String(format: "%.2f", value)
        }
    }
    
    /// Get a short time string for the data point
    var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: startDate)
    }
    
    /// Get a date string for the data point
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: startDate)
    }
}
