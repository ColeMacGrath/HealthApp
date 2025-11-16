//
//  HealthKitManager.swift
//  HealthApp
//
//  Created by Moises Cordova on 11/15/2025.
//

import Foundation
import HealthKit

@MainActor
final class HealthKitManager {
    static let shared = HealthKitManager()
    let healthStore = HKHealthStore()
    private init() {}
    
    var allRequiredTypes: Set<HKObjectType> {
        Set([HKQuantityType(.stepCount), HKQuantityType(.activeEnergyBurned), HKQuantityType(.basalEnergyBurned), HKQuantityType(.heartRate), HKQuantityType(.bodyMass), HKQuantityType(.height),
            HKQuantityType(.bodyMassIndex), HKCategoryType(.sleepAnalysis), HKQuantityType(.dietaryEnergyConsumed), HKQuantityType(.dietaryProtein), HKQuantityType(.dietaryCarbohydrates),
            HKQuantityType(.dietaryFatTotal), HKQuantityType(.dietaryFatSaturated), HKQuantityType(.dietaryFatMonounsaturated), HKQuantityType(.dietaryFatPolyunsaturated),
            HKQuantityType(.dietaryCholesterol), HKQuantityType(.dietarySodium), HKQuantityType(.dietaryPotassium), HKQuantityType(.dietaryCalcium), HKQuantityType(.dietaryIron),
            HKQuantityType(.dietaryZinc), HKQuantityType(.dietaryMagnesium), HKQuantityType(.dietaryPhosphorus), HKQuantityType(.dietaryVitaminA), HKQuantityType(.dietaryVitaminB6),
            HKQuantityType(.dietaryVitaminB12), HKQuantityType(.dietaryVitaminC), HKQuantityType(.dietaryVitaminD), HKQuantityType(.dietaryVitaminE), HKQuantityType(.dietaryVitaminK),
            HKQuantityType(.dietaryFolate), HKQuantityType(.dietaryFiber), HKQuantityType(.dietarySugar), HKQuantityType(.dietaryCaffeine), HKQuantityType(.dietaryWater)
        ])
    }
    
    func requestAuthorization() async throws {
        guard HKHealthStore.isHealthDataAvailable() else {
            throw HealthKitError.healthDataNotAvailable
        }
        
        let typesToRead = Set([
            HKQuantityType(.stepCount), HKQuantityType(.activeEnergyBurned), HKQuantityType(.basalEnergyBurned), HKQuantityType(.heartRate), HKQuantityType(.bodyMass), HKQuantityType(.height),
            HKQuantityType(.bodyMassIndex), HKCategoryType(.sleepAnalysis), HKQuantityType(.dietaryEnergyConsumed), HKQuantityType(.dietaryProtein), HKQuantityType(.dietaryCarbohydrates),
            HKQuantityType(.dietaryFatTotal), HKQuantityType(.dietaryFatSaturated), HKQuantityType(.dietaryFatMonounsaturated), HKQuantityType(.dietaryFatPolyunsaturated),
            HKQuantityType(.dietaryCholesterol), HKQuantityType(.dietarySodium), HKQuantityType(.dietaryPotassium), HKQuantityType(.dietaryCalcium), HKQuantityType(.dietaryIron),
            HKQuantityType(.dietaryZinc), HKQuantityType(.dietaryMagnesium), HKQuantityType(.dietaryPhosphorus), HKQuantityType(.dietaryVitaminA), HKQuantityType(.dietaryVitaminB6),
            HKQuantityType(.dietaryVitaminB12), HKQuantityType(.dietaryVitaminC), HKQuantityType(.dietaryVitaminD), HKQuantityType(.dietaryVitaminE), HKQuantityType(.dietaryVitaminK),
            HKQuantityType(.dietaryFolate), HKQuantityType(.dietaryFiber), HKQuantityType(.dietarySugar), HKQuantityType(.dietaryCaffeine), HKQuantityType(.dietaryWater)
        ])
        
        try await healthStore.requestAuthorization(toShare: [], read: typesToRead)
    }
    
    func retrieve(_ type: HealthDataType, from startDate: Date, to endDate: Date) async throws -> [HealthKitDataPoint] {
        switch type {
        case .steps:
            return try await fetchQuantityGroupedByDay(quantityType: HKQuantityType(.stepCount), unit: .count(), from: startDate, to: endDate)
        case .activeCalories:
            return try await fetchQuantityGroupedByDay(quantityType: HKQuantityType(.activeEnergyBurned), unit: .kilocalorie(), from: startDate, to: endDate)
        case .basalCalories:
            return try await fetchQuantityGroupedByDay(quantityType: HKQuantityType(.basalEnergyBurned), unit: .kilocalorie(), from: startDate, to: endDate)
        case .sleep:
            return try await fetchSleepSessions(from: startDate, to: endDate)
        case .heartRate:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.heartRate), unit: HKUnit.count().unitDivided(by: .minute()), from: startDate, to: endDate)
        case .weight:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.bodyMass), unit: .gramUnit(with: .kilo), from: startDate, to: endDate)
        case .height:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.height), unit: .meter(), from: startDate, to: endDate)
        case .bodyMassIndex:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.bodyMassIndex), unit: .count(), from: startDate, to: endDate)
        case .dietaryEnergy:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.dietaryEnergyConsumed), unit: .kilocalorie(), from: startDate, to: endDate)
        case .protein:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.dietaryProtein), unit: .gram(), from: startDate, to: endDate)
        case .carbohydrates:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.dietaryCarbohydrates), unit: .gram(), from: startDate, to: endDate)
        case .totalFat:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.dietaryFatTotal), unit: .gram(), from: startDate, to: endDate)
        case .saturatedFat:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.dietaryFatSaturated), unit: .gram(), from: startDate, to: endDate)
        case .monounsaturatedFat:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.dietaryFatMonounsaturated), unit: .gram(), from: startDate, to: endDate)
        case .polyunsaturatedFat:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.dietaryFatPolyunsaturated), unit: .gram(), from: startDate, to: endDate)
        case .cholesterol:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.dietaryCholesterol), unit: .gramUnit(with: .milli), from: startDate, to: endDate)
        case .sodium:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.dietarySodium), unit: .gramUnit(with: .milli), from: startDate, to: endDate)
        case .potassium:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.dietaryPotassium), unit: .gramUnit(with: .milli), from: startDate, to: endDate)
        case .calcium:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.dietaryCalcium), unit: .gramUnit(with: .milli), from: startDate, to: endDate)
        case .iron:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.dietaryIron), unit: .gramUnit(with: .milli), from: startDate, to: endDate)
        case .zinc:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.dietaryZinc), unit: .gramUnit(with: .milli), from: startDate, to: endDate)
        case .vitaminA:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.dietaryVitaminA), unit: .gramUnit(with: .micro), from: startDate, to: endDate)
        case .vitaminB6:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.dietaryVitaminB6), unit: .gramUnit(with: .milli), from: startDate, to: endDate)
        case .vitaminB12:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.dietaryVitaminB12), unit: .gramUnit(with: .micro), from: startDate, to: endDate)
        case .vitaminC:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.dietaryVitaminC), unit: .gramUnit(with: .milli), from: startDate, to: endDate)
        case .vitaminD:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.dietaryVitaminD), unit: .gramUnit(with: .micro), from: startDate, to: endDate)
        case .vitaminE:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.dietaryVitaminE), unit: .gramUnit(with: .milli), from: startDate, to: endDate)
        case .vitaminK:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.dietaryVitaminK), unit: .gramUnit(with: .micro), from: startDate, to: endDate)
        case .folate:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.dietaryFolate), unit: .gramUnit(with: .micro), from: startDate, to: endDate)
        case .magnesium:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.dietaryMagnesium), unit: .gramUnit(with: .milli), from: startDate, to: endDate)
        case .phosphorus:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.dietaryPhosphorus), unit: .gramUnit(with: .milli), from: startDate, to: endDate)
        case .fiber:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.dietaryFiber), unit: .gram(), from: startDate, to: endDate)
        case .sugar:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.dietarySugar), unit: .gram(), from: startDate, to: endDate)
        case .caffeine:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.dietaryCaffeine), unit: .gramUnit(with: .milli), from: startDate, to: endDate)
        case .water:
            return try await fetchIndividualQuantities(quantityType: HKQuantityType(.dietaryWater), unit: .literUnit(with: .milli), from: startDate, to: endDate)
        }
    }
    
    func checkAuthorizationStatus() -> HealthKitAuthorizationStatus {
        guard HKHealthStore.isHealthDataAvailable() else { return .unavailable }
        guard UserDefaults.standard.bool(forKey: "HealthKitAuthorizationRequested") else { return .notDetermined(types: Array(allRequiredTypes)) }
        let lastSuccessfulFetch = UserDefaults.standard.object(forKey: "HealthKitLastSuccessfulFetch") as? Date
        
        if let lastFetch = lastSuccessfulFetch {
            let oneHourAgo = Date().addingTimeInterval(-1)
            if lastFetch > oneHourAgo {
                return .authorized
            }
        }
        return .authorized
    }
    
    func checkAuthorizationStatusByQuery() async -> HealthKitAuthorizationStatus {
        guard HKHealthStore.isHealthDataAvailable() else { return .unavailable }
        guard UserDefaults.standard.bool(forKey: "HealthKitAuthorizationRequested") else { return .notDetermined(types: Array(allRequiredTypes)) }
        let stepType = HKQuantityType(.stepCount)
        let now = Date()
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: now)!
        
        do {
            let _ = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Bool, Error>) in
                let predicate = HKQuery.predicateForSamples(withStart: thirtyDaysAgo, end: now, options: .strictStartDate)
                
                let query = HKSampleQuery(
                    sampleType: stepType,
                    predicate: predicate,
                    limit: 1,
                    sortDescriptors: nil
                ) { _, samples, error in
                    if let error = error {
                        let nsError = error as NSError
                        if nsError.domain == "com.apple.healthkit" && nsError.code == 5 {
                            continuation.resume(throwing: HealthKitError.authorizationDenied)
                        } else {
                            continuation.resume(throwing: error)
                        }
                    } else {
                        continuation.resume(returning: true)
                    }
                }
                
                getHealthStore().execute(query)
            }
            
            markSuccessfulDataFetch()
            return .authorized
            
        } catch let error as HealthKitError where error == .authorizationDenied {
            return .denied(types: Array(allRequiredTypes))
        } catch {
            return .authorized
        }
    }
    
    func verifyAccessByDataFetch() async -> Bool {
        let stepType = HKQuantityType(.stepCount)
        let now = Date()
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: now)!
        
        do {
            _ = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                let predicate = HKQuery.predicateForSamples(withStart: weekAgo, end: now, options: .strictStartDate)
                
                let query = HKSampleQuery(
                    sampleType: stepType,
                    predicate: predicate,
                    limit: 1,
                    sortDescriptors: nil
                ) { _, _, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: ())
                    }
                }
                
                getHealthStore().execute(query)
            }
            
            markSuccessfulDataFetch()
            return true
        } catch {
            return false
        }
    }
    
    func markAuthorizationRequested() {
        UserDefaults.standard.set(true, forKey: "HealthKitAuthorizationRequested")
        markSuccessfulDataFetch()
    }
    
    func markSuccessfulDataFetch() {
        UserDefaults.standard.set(Date(), forKey: "HealthKitLastSuccessfulFetch")
    }
    
    func markDataFetchFailed() {
        UserDefaults.standard.removeObject(forKey: "HealthKitLastSuccessfulFetch")
    }
    
    func resetAuthorizationStatus() {
        UserDefaults.standard.removeObject(forKey: "HealthKitAuthorizationRequested")
        UserDefaults.standard.removeObject(forKey: "HealthKitLastSuccessfulFetch")
    }
    
    func getHealthStore() -> HKHealthStore {
        HKHealthStore()
    }
    
    private func fetchQuantityGroupedByDay(quantityType: HKQuantityType, unit: HKUnit, from startDate: Date, to endDate: Date) async throws -> [HealthKitDataPoint] {
        return try await withCheckedThrowingContinuation { continuation in
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            
            var interval = DateComponents()
            interval.day = 1
            
            let query = HKStatisticsCollectionQuery(
                quantityType: quantityType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum,
                anchorDate: Calendar.current.startOfDay(for: startDate),
                intervalComponents: interval
            )
            
            query.initialResultsHandler = { _, results, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let results = results else {
                    continuation.resume(returning: [])
                    return
                }
                
                var dataPoints: [HealthKitDataPoint] = []
                
                results.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                    if let sum = statistics.sumQuantity() {
                        let value = sum.doubleValue(for: unit)
                        let dataPoint = HealthKitDataPoint(
                            startDate: statistics.startDate,
                            endDate: statistics.endDate,
                            value: value
                        )
                        dataPoints.append(dataPoint)
                    }
                }
                
                continuation.resume(returning: dataPoints)
            }
            
            healthStore.execute(query)
        }
    }
    
    private func fetchIndividualQuantities(quantityType: HKQuantityType, unit: HKUnit, from startDate: Date, to endDate: Date) async throws -> [HealthKitDataPoint] {
        return try await withCheckedThrowingContinuation { continuation in
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
            
            let query = HKSampleQuery(
                sampleType: quantityType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let samples = samples as? [HKQuantitySample] else {
                    continuation.resume(returning: [])
                    return
                }
                
                let dataPoints = samples.map { sample in
                    HealthKitDataPoint(
                        startDate: sample.startDate,
                        endDate: sample.endDate,
                        value: sample.quantity.doubleValue(for: unit)
                    )
                }
                
                continuation.resume(returning: dataPoints)
            }
            
            healthStore.execute(query)
        }
    }
    
    private func fetchSleepSessions(from startDate: Date, to endDate: Date) async throws -> [HealthKitDataPoint] {
        return try await withCheckedThrowingContinuation { continuation in
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
            
            let query = HKSampleQuery(
                sampleType: HKCategoryType(.sleepAnalysis),
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let samples = samples as? [HKCategorySample] else {
                    continuation.resume(returning: [])
                    return
                }
                
                let sleepSamples = samples.filter { sample in
                    let value = HKCategoryValueSleepAnalysis(rawValue: sample.value)
                    return value == .asleepUnspecified || value == .asleepCore || value == .asleepDeep || value == .asleepREM
                }
                
                var sessions: [HealthKitDataPoint] = []
                var currentSessionStart: Date?
                var currentSessionEnd: Date?
                
                for sample in sleepSamples {
                    if let sessionStart = currentSessionStart, let sessionEnd = currentSessionEnd {
                        let timeDifference = sample.startDate.timeIntervalSince(sessionEnd)
                        if timeDifference <= 30 * 60 {
                            currentSessionEnd = sample.endDate
                        } else {
                            let duration = sessionEnd.timeIntervalSince(sessionStart) / 3600
                            sessions.append(HealthKitDataPoint(
                                startDate: sessionStart,
                                endDate: sessionEnd,
                                value: duration
                            ))
                            currentSessionStart = sample.startDate
                            currentSessionEnd = sample.endDate
                        }
                    } else {
                        currentSessionStart = sample.startDate
                        currentSessionEnd = sample.endDate
                    }
                }
                
                if let sessionStart = currentSessionStart, let sessionEnd = currentSessionEnd {
                    let duration = sessionEnd.timeIntervalSince(sessionStart) / 3600
                    sessions.append(HealthKitDataPoint(
                        startDate: sessionStart,
                        endDate: sessionEnd,
                        value: duration
                    ))
                }
                
                continuation.resume(returning: sessions)
            }
            
            healthStore.execute(query)
        }
    }
}
