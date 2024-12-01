//
//  DashboardModel.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-10-30.
//

import Foundation
import SwiftUI


@MainActor
@Observable
class DashboardModel: ObservableObject {
    var stepsCount: Int?
    var distance: Double?
    var heartRate: Int?
    var sleepHours: Int?
    var weight: Double?
    var calories: Int?
    var showSettingsAlert = false
    let healthKitManager = HealthKitManager()
    
    init() {
        Task {
            await fetchData()
        }
    }
    
    func fetchData(from: Date = Date()) async {
        let authorized = await healthKitManager.requestAuthorization()
        
        guard authorized && healthKitManager.isHealthDataAuthorized() else {
            showSettingsAlert = true
            return
        }
        
        
        let startOfDay = Calendar.current.startOfDay(for: from)
        async let steps = healthKitManager.fetchData(for: .stepCount, from: startOfDay, to: from)?.value
        async let distance = healthKitManager.fetchData(for: .distanceWalkingRunning, from: startOfDay, to: from)?.value
        async let heartRate = healthKitManager.fetchLatestHeartRate()?.value
        async let sleepHours = healthKitManager.fetchLastSleepSession()?.value
        async let weightValue = healthKitManager.fetchLatestWeight()?.value
        async let calories = healthKitManager.fetchData(for: .activeEnergyBurned, from: startOfDay, to: from)?.value
        
        self.stepsCount = await Int(steps ?? .zero)
        self.distance = await distance
        self.heartRate = await Int(heartRate ?? .zero)
        self.sleepHours = await Int(sleepHours ?? .zero)
        self.weight = await weightValue
        self.calories = await Int(calories ?? .zero)
    }
}
