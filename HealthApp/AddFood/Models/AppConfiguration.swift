//
//  AppConfiguration.swift
//  HealthApp
//
//  Created by Moises Cordova on 11/15/2025.
//

import Foundation

enum AppConfiguration {
    static var openAIAPIKey: String? {
        return ProcessInfo.processInfo.environment["OPENAI_API_KEY"]
    }
    static let openAIModel = "gpt-4o"
    static let openAIMaxTokens = 1500
    static let openAITemperature = 0.7
    static let imageCompressionQuality = 0.8
    static let isDebugMode = true
    static let simulateOpenAIResponses = true
    static var isOpenAIConfigured: Bool {
        return simulateOpenAIResponses ? true : ((openAIAPIKey?.isEmpty) == nil) && ((openAIAPIKey?.hasPrefix("sk-")) != nil)
    }
    
    static var configurationStatus: String {
        isOpenAIConfigured ? "✅ OpenAI API configured" : "⚠️ Please set your OpenAI API key in AppConfiguration.swift"
    }
}
