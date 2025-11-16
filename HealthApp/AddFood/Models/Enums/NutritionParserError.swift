//
//  NutritionParserError.swift
//  HealthApp
//
//  Created by Moises Cordova on 11/15/2025.
//

import Foundation
import FoundationModels

enum NutritionParserError: LocalizedError {
    case modelUnavailable(SystemLanguageModel.Availability)
    case invalidResponse
    case parsingFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .modelUnavailable(let availability):
            switch availability {
            case .available:
                return "Model is available but initialization failed"
            case .unavailable(.deviceNotEligible):
                return "Device not eligible for Apple Intelligence"
            case .unavailable(.appleIntelligenceNotEnabled):
                return "Apple Intelligence is not enabled. Please enable it in Settings."
            case .unavailable(.modelNotReady):
                return "Model is downloading or not ready. Please try again later."
            case .unavailable(let other):
                return "Model unavailable: \(other)"
            @unknown default:
                return "Model unavailable for unknown reason"
            }
        case .invalidResponse:
            return "Invalid response from Foundation Model"
        case .parsingFailed(let error):
            return "Failed to parse nutrition data: \(error.localizedDescription)"
        }
    }
}
