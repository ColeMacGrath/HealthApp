//
//  HealthKitManager.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 30/12/23.
//

import Foundation
import UIKit
import HealthKit
import Security

class HealthKitManager {
    static let shared = HealthKitManager()
    private let fitzpatrickIdentifier = "FitzpatrickSkinType"
    private let healthStore = HKHealthStore()
    private let typesToRead: Set<HKSampleType> = [
        HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
        HKObjectType.quantityType(forIdentifier: .bodyMass)!,
        HKObjectType.quantityType(forIdentifier: .heartRate)!,
        HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
        HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!
    ]
    let characteristicTypesToRead: Set<HKObjectType> = [
        HKObjectType.characteristicType(forIdentifier: .biologicalSex)!,
        HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
        HKObjectType.characteristicType(forIdentifier: .bloodType)!,
        HKObjectType.characteristicType(forIdentifier: .fitzpatrickSkinType)!,
        HKObjectType.characteristicType(forIdentifier: .wheelchairUse)!
    ]
    init() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
    }
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        let typesToShare: Set<HKSampleType> = Set(self.typesToRead.compactMap { $0 })
        let allTypesToRead: Set<HKObjectType> = Set(self.typesToRead.map { $0 as HKObjectType }).union(self.characteristicTypesToRead)
        self.healthStore.requestAuthorization(toShare: typesToShare, read: allTypesToRead) { success, error in
            let allPermissionsGranted = typesToShare.allSatisfy { type in
                return self.healthStore.authorizationStatus(for: type) == .sharingAuthorized
            }
            completion(allPermissionsGranted, error)
        }
    }
    
    func quantityRecordsFor(typeIdentifier: HKQuantityTypeIdentifier, withUnit unit: HKUnit, from startDate: Date? = nil, to endDate: Date? = nil, completion: @escaping ([(date: Date, value: Double)]) -> Void) {
        guard let type = HKObjectType.quantityType(forIdentifier: typeIdentifier) else {
            completion([])
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
            guard let samples = results as? [HKQuantitySample] else {
                completion([])
                return
            }
            completion(self.processQuantitySamples(samples, withUnit: unit))
        }
        
        self.healthStore.execute(query)
    }
    
    func latestQuantityRecordFor(typeIdentifier: HKQuantityTypeIdentifier, withUnit unit: HKUnit, completion: @escaping ((date: Date, value: Double)?) -> Void) {
        guard let type = HKObjectType.quantityType(forIdentifier: typeIdentifier) else {
            completion(nil)
            return
        }

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: type, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            guard let sample = results?.first as? HKQuantitySample else {
                completion(nil)
                return
            }
            completion(self.processQuantitySamples([sample], withUnit: unit).first)
        }

        self.healthStore.execute(query)
    }

    
    func processQuantitySamples(_ samples: [HKQuantitySample], withUnit unit: HKUnit) -> [(date: Date, value: Double)] {
        return samples.map { sample in
            let date = sample.startDate
            let value = sample.quantity.doubleValue(for: unit)
            return (date, value)
        }
    }
    
    func categoryRecordsFor(typeIdentifier: HKCategoryTypeIdentifier, from startDate: Date? = nil, to endDate: Date? = nil, completion: @escaping ([HKCategorySample]?,[(date: Date, value: String)]) -> Void) {
        guard let type = HKObjectType.categoryType(forIdentifier: typeIdentifier) else {
            completion(nil, [])
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
            guard let samples = results as? [HKCategorySample] else {
                completion(nil, [])
                return
            }
            completion(samples, self.processCategorySamples(samples))
        }
        
        self.healthStore.execute(query)
    }
    
    func latestCategoryRecordFor(typeIdentifier: HKCategoryTypeIdentifier, completion: @escaping ((date: Date, value: String)?) -> Void) {
        guard let type = HKObjectType.categoryType(forIdentifier: typeIdentifier) else {
            completion(nil)
            return
        }

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: type, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            guard let sample = results?.first as? HKCategorySample else {
                completion(nil)
                return
            }
            
            completion(self.processCategorySamples([sample]).first)
        }

        self.healthStore.execute(query)
    }
    
    func processCategorySamples(_ samples: [HKCategorySample]) -> [(date: Date, value: String)] {
        return samples.map { sample in
            let date = sample.startDate
            let value = (sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue) ? "In Bed" : "Asleep"
            return (date, value)
        }
    }
    
    func findLatestContinuousSleepSession(from samples: [HKCategorySample]) -> (start: Date, end: Date)? {
        let gapThreshold: TimeInterval = 30 * 60
        
        let latestSession = samples
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
        
        return latestSession
    }
    
    func getBiologicalSex(completion: @escaping (String) -> Void) {
        do {
            let biologicalSex = try self.healthStore.biologicalSex().biologicalSex
            completion(self.readbleBiologicalSex(biologicalSex: biologicalSex))
        } catch {
            completion("Unknown")
        }
    }
    
    private func readbleBiologicalSex(biologicalSex: HKBiologicalSex) -> String {
        switch biologicalSex {
        case .female:
            return "Female"
        case .male:
            return "Male"
        case .other:
            return "Other"
        case .notSet:
            return "Not Set"
        @unknown default:
            return "Unknown"
        }
    }
    
    func getAge(completion: @escaping (Int?) -> Void) {
        do {
            let birthdayComponents = try self.healthStore.dateOfBirthComponents()
            let calendar = Calendar.current
            let currentYear = calendar.component(.year, from: Date())
            guard let year = birthdayComponents.year else { completion(nil); return }
            let age = currentYear - year
            completion(age)
        } catch {
            completion(nil)
        }
    }
    
    func getBloodType(completion: @escaping (String) -> Void) {
        do {
            let bloodType = try self.healthStore.bloodType().bloodType
            completion(self.getReadbleBloddType(bloodType: bloodType))
        } catch {
            completion("Not Set")
        }
    }
    
    private func getReadbleBloddType(bloodType: HKBloodType) -> String {
        switch bloodType {
        case .notSet:
            return "Not Set"
        case .aPositive:
            return "A+"
        case .aNegative:
            return "A-"
        case .bPositive:
            return "B+"
        case .bNegative:
            return "B-"
        case .abPositive:
            return "AB+"
        case .abNegative:
            return "AB-"
        case .oPositive:
            return "O+"
        case .oNegative:
            return "O-"
        @unknown default:
            return "Unknown"
        }
    }
    
    func getFitzpatrickSkinType(completion: @escaping (String?, UIColor?) -> Void) {
        if let fitzpatrickSkinType = self.retrieveSecureFitzpatrickSkinType(),
           let hkfitzpatrickSkinType = HKFitzpatrickSkinType(rawValue: fitzpatrickSkinType) {
            completion(self.getReadbleFitzpatrickSkinType(fitzpatrickSkinType: hkfitzpatrickSkinType), UIColor.colorFrom(skinType: hkfitzpatrickSkinType))
        } else {
            do {
                let skinType = try healthStore.fitzpatrickSkinType().skinType
                completion(self.getReadbleFitzpatrickSkinType(fitzpatrickSkinType: skinType), UIColor.colorFrom(skinType: skinType))
            } catch {
                completion(nil, nil)
            }
        }
    }
    
    func saveFitzpatrick(skinType: Int) -> Bool {
        let data = Data(from: skinType)
        let query: [String : Any] = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: self.fitzpatrickIdentifier,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)
        return SecItemAdd(query as CFDictionary, nil) == noErr
    }
    
    func retrieveSecureFitzpatrickSkinType() -> Int? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : self.fitzpatrickIdentifier,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]
        
        var dataTypeRef: AnyObject?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == noErr,
           let dataTypeRef = dataTypeRef as? Data {
            return Data.toInteger(data: dataTypeRef)
        }
        return nil
    }

    
    private func getReadbleFitzpatrickSkinType(fitzpatrickSkinType: HKFitzpatrickSkinType) -> String {
        switch fitzpatrickSkinType {
        case .notSet:
            return "Not Set"
        case .I:
            return "I"
        case .II:
            return "II"
        case .III:
            return "III"
        case .IV:
            return "IV"
        case .V:
            return "V"
        case .VI:
            return "VI"
        @unknown default:
            return "Unknown"
        }
    }
    
    func getWheelchairUse(completion: @escaping (Bool) -> Void) {
        do {
            let wheelchairUse = try self.healthStore.wheelchairUse().wheelchairUse
            
            completion(wheelchairUse == .yes)
        } catch {
            completion(false)
        }
    }
    
    func colorForFitzpatrickSkinType(_ skinType: HKFitzpatrickSkinType) -> UIColor {
        switch skinType {
        case .notSet:
            return .clear
        case .I:
            return UIColor(red: 1.00, green: 0.90, blue: 0.80, alpha: 1.0)
        case .II:
            return UIColor(red: 0.98, green: 0.82, blue: 0.70, alpha: 1.0)
        case .III:
            return UIColor(red: 0.80, green: 0.67, blue: 0.54, alpha: 1.0)
        case .IV:
            return UIColor(red: 0.60, green: 0.48, blue: 0.39, alpha: 1.0)
        case .V:
            return UIColor(red: 0.45, green: 0.34, blue: 0.28, alpha: 1.0)
        case .VI:
            return UIColor(red: 0.29, green: 0.24, blue: 0.20, alpha: 1.0)
        @unknown default:
            return UIColor.clear
        }
    }
    
    func fetchIngestedFood(from startDate: Date? = nil, to endDate: Date? = nil, completion: @escaping ([(foodName: String, calories: Double)]?) -> Void) {
        guard let foodType = HKObjectType.correlationType(forIdentifier: .food),
              let calorieType = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed) else {
            completion(nil)
            return
        }

        let predicate: NSPredicate
        if let startDate = startDate, let endDate = endDate {
            predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        } else {
            predicate = HKQuery.predicateForSamples(withStart: nil, end: nil, options: .strictStartDate)
        }

        let query = HKCorrelationQuery(type: foodType, predicate: predicate, samplePredicates: nil) { query, results, error in
            guard let foodCorrelations = results else {
                print("Error fetching food correlations: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            let foodData = foodCorrelations.flatMap { correlation -> [(foodName: String, calories: Double)] in
                let foodName = correlation.metadata?[HKMetadataKeyFoodType] as? String ?? "Unknown Food"
                let calorieSamples = correlation.objects.filter { $0.sampleType == calorieType }

                let totalCalories = calorieSamples.reduce(0.0) { total, sample in
                    let quantitySample = sample as? HKQuantitySample
                    return total + (quantitySample?.quantity.doubleValue(for: HKUnit.kilocalorie()) ?? 0.0)
                }

                return [(foodName, totalCalories)]
            }

            completion(foodData)
        }

        self.healthStore.execute(query)
    }
    
    func fetchLastIngestedFood(completion: @escaping ((foodName: String, calories: Double)?) -> Void) {
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed) else {
            completion(nil)
            return
        }
        let query = HKSampleQuery(sampleType: quantityType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            guard let samples = samples,
                  let mostRecentSample = samples.first as? HKQuantitySample else {
                completion(nil)
                return
            }
            
            let calories = mostRecentSample.quantity.doubleValue(for: HKUnit.kilocalorie())
            guard let foodName = mostRecentSample.metadata?[HKMetadataKeyFoodType] as? String else {
                completion(nil)
                return
            }
            completion((foodName, calories))
        }
        
        healthStore.execute(query)
    }
    
    func getUnitFor(identifier: HKQuantityTypeIdentifier) -> HKUnit? {
        switch identifier {
        case .activeEnergyBurned:
            return HKUnit(from: "kcal")
        case .bodyMass:
            return HKUnit(from: "kg")
        case .heartRate:
            return HKUnit(from: "count/min")
        default:
            return nil
        }
    }

}

