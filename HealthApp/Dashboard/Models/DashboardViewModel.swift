//
//  DashboardViewModel.swift
//  HealthApp
//
//  Created by Moises Cordova on 11/15/2025.
//

import UIKit

@Observable
@MainActor
final class DashboardViewModel {
    var isLoading = false
    var errorMessage: String?
    var authorizationStatus: HealthKitAuthorizationStatus = .notDetermined(types: [])
    var showPermissionModal = false
    var stepsData: [HealthKitDataPoint] = []
    var heartRateData: [HealthKitDataPoint] = []
    var sleepSessions: [HealthKitDataPoint] = []
    var activeCaloriesData: [HealthKitDataPoint] = []
    var weightData: [HealthKitDataPoint] = []
    var proteinData: [HealthKitDataPoint] = []
    var carbsData: [HealthKitDataPoint] = []
    var fatData: [HealthKitDataPoint] = []
    var calciumData: [HealthKitDataPoint] = []
    var potassiumData: [HealthKitDataPoint] = []
    var totalStepsToday: Double {
        stepsData.last?.value ?? 0
    }
    var averageHeartRate: Double {
        guard !heartRateData.isEmpty else { return 0 }
        let sum = heartRateData.reduce(0) { $0 + $1.value }
        return sum / Double(heartRateData.count)
    }
    var lastNightSleep: Double {
        sleepSessions.last?.value ?? 0
    }
    var totalCaloriesToday: Double {
        let proteinCal = proteinData.reduce(0) { $0 + $1.value } * 4
        let carbsCal = carbsData.reduce(0) { $0 + $1.value } * 4
        let fatCal = fatData.reduce(0) { $0 + $1.value } * 9
        return proteinCal + carbsCal + fatCal
    }
    
    func checkAuthorizationStatus() {
        authorizationStatus = HealthKitManager.shared.checkAuthorizationStatus()
        showPermissionModal = !authorizationStatus.isAuthorized
    }
    
    func requestHealthKitAuthorization() async {
        do {
            try await HealthKitManager.shared.requestAuthorization()
            HealthKitManager.shared.markAuthorizationRequested()
            checkAuthorizationStatus()
            if authorizationStatus.isAuthorized {
                await loadHealthData()
            }
        } catch {
            errorMessage = "Failed to authorize HealthKit: \(error.localizedDescription)"
        }
    }
    
    func openHealthSettings() {
        if let url = URL(string: "x-apple-health://") {
            Task { @MainActor in
                if UIApplication.shared.canOpenURL(url) {
                    await UIApplication.shared.open(url)
                } else if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    await UIApplication.shared.open(settingsURL)
                }
            }
        }
    }
    
    func checkAndReloadIfAuthorized() async {
        authorizationStatus = await HealthKitManager.shared.checkAuthorizationStatusByQuery()
        showPermissionModal = !authorizationStatus.isAuthorized
        
        if authorizationStatus.isAuthorized {
            await loadHealthData()
        }
    }
    
    func loadHealthData() async {
        guard authorizationStatus.isAuthorized else { return }
        isLoading = true
        defer { isLoading = false }
        
        let calendar = Calendar.current
        let now = Date()
        
        guard let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) else { return }
        let startOfToday = calendar.startOfDay(for: now)
        
        do {
            async let steps = HealthKitManager.shared.retrieve(.steps, from: weekAgo, to: now)
            async let activeCalories = HealthKitManager.shared.retrieve(.activeCalories, from: weekAgo, to: now)
            async let heartRate = HealthKitManager.shared.retrieve(.heartRate, from: weekAgo, to: now)
            async let sleep = HealthKitManager.shared.retrieve(.sleep, from: weekAgo, to: now)
            async let weight = HealthKitManager.shared.retrieve(.weight, from: weekAgo, to: now)
            async let protein = HealthKitManager.shared.retrieve(.protein, from: startOfToday, to: now)
            async let carbs = HealthKitManager.shared.retrieve(.carbohydrates, from: startOfToday, to: now)
            async let fat = HealthKitManager.shared.retrieve(.totalFat, from: startOfToday, to: now)
            async let calcium = HealthKitManager.shared.retrieve(.calcium, from: startOfToday, to: now)
            async let potassium = HealthKitManager.shared.retrieve(.potassium, from: startOfToday, to: now)
            
            (stepsData, activeCaloriesData, heartRateData, sleepSessions, weightData,
             proteinData, carbsData, fatData, calciumData, potassiumData) = try await (
                steps, activeCalories, heartRate, sleep, weight,
                protein, carbs, fat, calcium, potassium
            )
            
            HealthKitManager.shared.markSuccessfulDataFetch()
            
        } catch {
            errorMessage = "Failed to load health data: \(error.localizedDescription)"
            HealthKitManager.shared.markDataFetchFailed()
            
            Task {
                let hasAccess = await HealthKitManager.shared.verifyAccessByDataFetch()
                if !hasAccess {
                    authorizationStatus = .denied(types: Array(HealthKitManager.shared.allRequiredTypes))
                    showPermissionModal = true
                }
            }
        }
    }
    
    func loadData(for type: HealthDataType, from startDate: Date, to endDate: Date) async -> [HealthKitDataPoint] {
        do {
            return try await HealthKitManager.shared.retrieve(type, from: startDate, to: endDate)
        } catch {
            errorMessage = "Failed to load \(type): \(error.localizedDescription)"
            return []
        }
    }
    
    func convertToHealthDataPoint(_ healthKitData: [HealthKitDataPoint]) -> [HealthDataPoint] {
        healthKitData.map { dataPoint in
            HealthDataPoint(
                date: dataPoint.startDate,
                value: dataPoint.value
            )
        }
    }
    
    func formatHeartRate(_ value: Double) -> String {
        guard value > 0 else { return "--" }
        return String(format: "%.0f bpm", value)
    }

    func formatSteps(_ value: Double) -> String {
        guard value > 0 else { return "--" }
        return String(format: "%.0f", value).replacingOccurrences(of: ",", with: ",")
    }
    
    func formatCalories(_ value: Double) -> String {
        guard value > 0 else { return "0" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "0"
    }
    
    func formatSleep(_ hours: Double) -> String {
        guard hours > 0 else { return "--" }
        let h = Int(hours)
        let m = Int((hours - Double(h)) * 60)
        return "\(h)h \(m)m"
    }
    
    func formatWeight(_ value: Double) -> String {
        guard value > 0 else { return "--" }
        return String(format: "%.1f kg", value)
    }
}
