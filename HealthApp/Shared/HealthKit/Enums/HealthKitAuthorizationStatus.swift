//
//  HealthKitAuthorizationStatus.swift
//  HealthApp
//
//  Created by Moises Cordova on 11/15/2025.
//

import Foundation
import HealthKit

enum HealthKitAuthorizationStatus: Sendable {
    case authorized
    case notDetermined(types: [HKObjectType])
    case denied(types: [HKObjectType])
    case unavailable
    
    var isAuthorized: Bool {
        if case .authorized = self {
            return true
        }
        return false
    }
    
    var needsAuthorization: Bool {
        switch self {
        case .authorized:
            return false
        case .notDetermined, .denied, .unavailable:
            return true
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .authorized:
            return "All permissions granted"
        case .notDetermined(let types):
            return "Need permission for \(types.count) health data types"
        case .denied(let types):
            return "\(types.count) permissions denied. Please enable in Settings."
        case .unavailable:
            return "HealthKit is not available on this device"
        }
    }
}
