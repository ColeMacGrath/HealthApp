//
//  GraphModel.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-11-09.
//

import Foundation
import HealthKit

@Observable
class GraphModel {
    private var hkObjectType: HKObjectType
    private var healthKitManager: HealthKitManager
    var groupedBy: GroupedBy
    var healthData: [HealthData]
    
    init(hkObjectType: HKObjectType, healthKitManager: HealthKitManager, groupedBy: GroupedBy = .week) {
        self.hkObjectType = hkObjectType
        self.healthKitManager = healthKitManager
        self.groupedBy = groupedBy
        self.healthData = []
    }
    
    @MainActor
    func fetchData() async {
        if let quantityType = hkObjectType as? HKQuantityType {
            let quantityType = HKQuantityTypeIdentifier(rawValue: quantityType.identifier)
            self.healthData = await (healthKitManager.fetchIndividualRecords(for: quantityType, from: .date(groupedBy: groupedBy), to: Date(), groupedBy: quantityType == .heartRate ? .all : groupedBy))?.sorted(by: { $0.startDate ?? Date() > $1.startDate ?? Date() }) ?? []
        } else if let categoryType = hkObjectType as? HKCategoryType {
            let categoryType = HKQuantityTypeIdentifier(rawValue: categoryType.identifier)
            self.healthData = await healthKitManager.fetchIndividualRecords(for: categoryType, from: .date(groupedBy: groupedBy), to: Date(), groupedBy: .day)?.sorted(by: { $0.startDate ?? Date() > $1.startDate ?? Date() }) ?? []
        } else {
            self.healthData = []
        }
    }
    
    func formatedHealthMetricTitle() -> String {
        switch hkObjectType {
        case HKQuantityType.quantityType(forIdentifier: .stepCount):
            return "Steps"
        case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning):
            return "Distance"
        case HKQuantityType.quantityType(forIdentifier: .heartRate):
            return "Hearth Rate"
        case HKCategoryType.categoryType(forIdentifier: .sleepAnalysis):
            return "Sleep"
        case HKQuantityType.quantityType(forIdentifier: .bodyMass):
            return "Body Mass"
        case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
            return "Calories Burned"
        default:
            return .empty
        }
    }
    
    func getFormatedTitleFor(value: Double?) -> (title: String, caption: String) {
        guard let value else { return (.empty, .empty) }
        switch hkObjectType {
        case HKQuantityType.quantityType(forIdentifier: .stepCount):
            return (String(Int(value)), "Steps")
        case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning):
            return (String(Int(value)), "Km")
        case HKQuantityType.quantityType(forIdentifier: .heartRate):
            return (String(Int(value)), "Bpm")
        case HKCategoryType.categoryType(forIdentifier: .sleepAnalysis):
            return ("8", "Hrs")
        case HKQuantityType.quantityType(forIdentifier: .bodyMass):
            return (String(Int(value)), "Kg")
        case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
            return (String(Int(value)), "Cal")
        default:
            return (.empty, .empty)
        }
    }

}
