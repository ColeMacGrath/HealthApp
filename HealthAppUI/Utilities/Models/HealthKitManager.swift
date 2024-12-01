//
//  HealthKitManager.swift
//  HealthAppUI
//
//  Created by Moisés Córdova on 2024-10-30.
//

import HealthKit
import Foundation
import UIKit
import SwiftUI

enum FitzPatrickScale: String {
    case I
    case II
    case III
    case IV
    case V
    case VI
}

enum GroupedBy: String, CaseIterable, Identifiable, Equatable {
    case all
    case day
    case week
    case month
    case year
    var id: String { rawValue }
}

actor HealthKitManager {
    private let healthStore = HKHealthStore()
    
    func requestAuthorization() async -> Bool {
        guard HKHealthStore.isHealthDataAvailable() else { return false }
        
        let readTypes: Set<HKObjectType> = Set([
            HKQuantityType.quantityType(forIdentifier: .stepCount),
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning),
            HKQuantityType.quantityType(forIdentifier: .heartRate),
            HKCategoryType.categoryType(forIdentifier: .sleepAnalysis),
            HKQuantityType.quantityType(forIdentifier: .bodyMass),
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)
        ].compactMap { $0 })
        
        do {
            try await healthStore.requestAuthorization(toShare: [], read: readTypes)
            return true
        } catch {
            print("HealthKit authorization failed: \(error)")
            return false
        }
    }
    
    @MainActor
    func isHealthDataAuthorized() -> Bool {
        return true
        /*let quantityIdentifiers: [HKQuantityTypeIdentifier] = [.stepCount, .distanceWalkingRunning, .heartRate, .bodyMass, .activeEnergyBurned]
         
         let quantityAuthorization = quantityIdentifiers.allSatisfy { identifier in
         guard let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else { return false }
         return healthStore.authorizationStatus(for: quantityType) == .sharingAuthorized
         }
         
         let sleepAuthorization = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)
         .map { healthStore.authorizationStatus(for: $0) == .sharingAuthorized } ?? false
         
         return quantityAuthorization && sleepAuthorization*/
    }
    
    @MainActor
    func openHealthApp() {
        guard let healthUrl = URL(string: "x-apple-health://"),
              UIApplication.shared.canOpenURL(healthUrl) else { return }
        UIApplication.shared.open(healthUrl)
    }
    
    func fetchData(for identifier: HKQuantityTypeIdentifier, from startDate: Date, to endDate: Date) async -> HealthData? {
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else { return nil }
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let options = statisticsOption(for: identifier)
        let unit = unit(for: identifier)
        
        return await fetchStatistics(for: quantityType, predicate: predicate, options: options, unit: unit)
    }
    
    func fetchIndividualRecords(for identifier: HKQuantityTypeIdentifier, from startDate: Date, to endDate: Date, groupedBy: GroupedBy) async -> [HealthData]? {
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else { return nil }
        return await fetchIndividualRecords(for: quantityType, from: startDate, to: endDate, groupedBy: groupedBy)
    }
    
    func fetchIndividualRecords(for quantityType: HKQuantityType, from startDate: Date, to endDate: Date, groupedBy: GroupedBy) async -> [HealthData]? {
        let unit = unit(for: HKQuantityTypeIdentifier(rawValue: quantityType.identifier))
        let allSamples = await fetchSamples(for: quantityType, from: startDate, to: endDate, unit: unit) ?? []
        
        switch groupedBy {
        case .all:
            return allSamples
        case .day:
            return groupSamplesByComponent(allSamples, unit: unit, component: .day)
        case .week:
            return groupSamplesByComponent(allSamples, unit: unit, component: .weekOfYear)
        case .month:
            return groupSamplesByComponent(allSamples, unit: unit, component: .month)
        case .year:
            return groupSamplesByComponent(allSamples, unit: unit, component: .year)
        }
    }
    
    private func groupSamplesByComponent(_ samples: [HealthData], unit: HKUnit, component: Calendar.Component) -> [HealthData] {
        let calendar = Calendar.current
        let groupedSamples = samples.reduce(into: [Date: Double]()) { result, sample in
            guard let startDate = sample.startDate, let value = sample.value else { return }
            let componentStart = calendar.startOfDay(for: startDate)
            result[componentStart, default: 0] += value
        }
        
        return groupedSamples.map { (date, totalValue) in
            HealthData(startDate: date, endDate: calendar.date(byAdding: component, value: 1, to: date), value: totalValue)
        }
    }
    
    private func statisticsOption(for identifier: HKQuantityTypeIdentifier) -> HKStatisticsOptions {
        switch identifier {
        case .stepCount, .distanceWalkingRunning, .activeEnergyBurned:
            return .cumulativeSum
        case .bodyMass, .heartRate:
            return .discreteAverage
        default:
            return .discreteAverage
        }
    }
    
    private func unit(for identifier: HKQuantityTypeIdentifier) -> HKUnit {
        switch identifier {
        case .stepCount:
            return .count()
        case .distanceWalkingRunning:
            return .meter()
        case .activeEnergyBurned:
            return .kilocalorie()
        case .bodyMass:
            return .gramUnit(with: .kilo)
        case .heartRate:
            return HKUnit(from: "count/min")
        default:
            return .count()
        }
    }
    
    func fetchLatestSample(for quantityType: HKQuantityType, unit: HKUnit) async -> HealthData? {
        return await withCheckedContinuation { continuation in
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            let query = HKSampleQuery(sampleType: quantityType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in
                
                if let error = error {
                    print("Failed to fetch latest sample: \(error)")
                    continuation.resume(returning: nil)
                } else if let quantitySample = samples?.first as? HKQuantitySample {
                    let value = quantitySample.quantity.doubleValue(for: unit)
                    continuation.resume(returning: HealthData(startDate: quantitySample.startDate, endDate: quantitySample.endDate, value: value))
                } else {
                    continuation.resume(returning: nil)
                }
            }
            healthStore.execute(query)
        }
    }
    
    private func fetchSamples(for quantityType: HKQuantityType, from startDate: Date, to endDate: Date, unit: HKUnit) async -> [HealthData]? {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        return await withCheckedContinuation { continuation in
            let query = HKSampleQuery(sampleType: quantityType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
                if let error = error {
                    continuation.resume(returning: nil)
                } else if let quantitySamples = samples as? [HKQuantitySample] {
                    let healthDataArray = quantitySamples.map { sample in
                        HealthData(startDate: sample.startDate, endDate: sample.endDate, value: sample.quantity.doubleValue(for: unit))
                    }
                    continuation.resume(returning: healthDataArray)
                } else {
                    continuation.resume(returning: nil)
                }
            }
            healthStore.execute(query)
        }
    }
    
    private func fetchStatistics(for quantityType: HKQuantityType, predicate: NSPredicate, options: HKStatisticsOptions, unit: HKUnit) async -> HealthData? {
        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: options) { _, statistics, error in
                if let error = error {
                    print("Failed to fetch data: \(error) for: \(unit.description)")
                    continuation.resume(returning: nil)
                } else if options == .cumulativeSum, let sum = statistics?.sumQuantity()?.doubleValue(for: unit) {
                    continuation.resume(returning: HealthData(startDate: statistics?.startDate, endDate: statistics?.endDate, value: sum))
                } else if options == .discreteAverage, let avg = statistics?.averageQuantity()?.doubleValue(for: unit) {
                    continuation.resume(returning: HealthData(startDate: statistics?.startDate, endDate: statistics?.endDate, value: avg))
                } else {
                    continuation.resume(returning: (nil))
                }
            }
            healthStore.execute(query)
        }
    }
    
    func fetchLastSleepSession() async -> HealthData? {
        guard let sleepType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis) else { return nil }
        
        let predicate = HKQuery.predicateForSamples(withStart: .distantPast, end: Date(), options: .strictStartDate)
        
        return await withCheckedContinuation { continuation in
            let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
                if let error = error {
                    print("Failed to fetch sleep data: \(error)")
                    continuation.resume(returning:  nil)
                } else {
                    let gapThreshold: TimeInterval = 30 * 60
                    guard let sessions = samples else {
                        continuation.resume(returning: nil)
                        return
                    }
                    
                    let latestSession = sessions
                        .sorted(by: { $0.startDate < $1.startDate })
                        .reduce(into: [(start: Date, end: Date)]()) { (sessions, sample) in
                            if let lastSession = sessions.last {
                                if sample.startDate <= lastSession.end.addingTimeInterval(gapThreshold) {
                                    sessions[sessions.count - 1].end = sample.endDate
                                } else {
                                    sessions.append((start: sample.startDate, end: sample.endDate))
                                }
                            } else {
                                sessions.append((start: sample.startDate, end: sample.endDate))
                            }
                        }.last
                    
                    if let startSession = latestSession?.start,
                       let endSession = latestSession?.end {
                        let duration = endSession.timeIntervalSince(startSession) / 3600
                        continuation.resume(returning: HealthData(startDate: startSession, endDate: endSession, value: duration))
                    } else {
                        continuation.resume(returning: nil)
                    }
                }
            }
            
            healthStore.execute(query)
        }
    }
    
    func fetchLatestHeartRate() async -> HealthData? {
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return nil }
        return await fetchLatestSample(for: quantityType, unit: HKUnit(from: "count/min"))
    }
    
    func fetchLatestWeight() async -> HealthData? {
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: .bodyMass) else { return nil }
        return await fetchLatestSample(for: quantityType, unit: HKUnit.gramUnit(with: .kilo))
    }
    
    @MainActor
    func getColorFor(fitzPatricScale: FitzPatrickScale) -> Color {
        switch fitzPatricScale {
        case .I:
            Color(red: 1.0, green: 0.878431, blue: 0.741176)
        case .II:
            Color(red: 1.0, green: 0.803922, blue: 0.580392)
        case .III:
            Color(red: 0.898039, green: 0.760784, blue: 0.596078)
        case .IV:
            Color(red: 0.803922, green: 0.643137, blue: 0.407843)
        case .V:
            Color(red: 0.631373, green: 0.458824, blue: 0.235294)
        case .VI:
            Color(red: 0.333333, green: 0.243137, blue: 0.133333)
        }
    }
    
}
