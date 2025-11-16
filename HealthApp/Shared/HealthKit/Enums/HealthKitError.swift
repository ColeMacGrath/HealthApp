//
//  HealthKitError.swift
//  HealthApp
//
//  Created by Moises Cordova on 11/15/2025.
//

import Foundation

enum HealthKitError: LocalizedError {
    case healthDataNotAvailable
    case authorizationDenied
    case noDataAvailable
    
    var errorDescription: String? {
        switch self {
        case .healthDataNotAvailable:
            return "Health data is not available on this device."
        case .authorizationDenied:
            return "Authorization to access health data was denied."
        case .noDataAvailable:
            return "No data available for the requested period."
        }
    }
}
