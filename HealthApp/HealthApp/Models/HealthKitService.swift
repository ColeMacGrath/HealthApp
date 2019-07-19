//
//  HealthKitService.swift
//  HealthApp
//
//  Created by Moisés Córdova on 7/9/19.
//  Copyright © 2019 Moisés Córdova. All rights reserved.
//

import Foundation
import HealthKit
import RealmSwift

class HealthKitService {
    private static let _shared = HealthKitService()
    let realm = try? Realm()
    let healthKitStore: HKHealthStore = HKHealthStore()
    static var shared: HealthKitService {
        return _shared
    }
    
    func getPacientBasicData() -> (age: Int?, bloodType: HKBloodTypeObject?, biologicalSex: HKBiologicalSexObject?) {
        var age: Int?
        var bloodType: HKBloodTypeObject?
        var biologicalSex: HKBiologicalSexObject?
        do {
            let birthDay = try healthKitStore.dateOfBirthComponents()
            let calendar = Calendar.current
            let currentYear = calendar.component(.year, from: Date())
            age = currentYear - birthDay.year!
        } catch {
            age = nil
        }
        
        do {
            bloodType = try healthKitStore.bloodType()
            biologicalSex = try healthKitStore.biologicalSex()
        } catch {
            //Algo salió mal al leer el perfil
        }
        return (age, bloodType, biologicalSex)
    }
    
    func getReadable(bloodType: HKBloodType?) -> String {
        var bloodTypeText = ""
        
        if bloodType != nil {
            switch(bloodType!) {
            case .aPositive:
                bloodTypeText = "A+"
            case .aNegative:
                bloodTypeText = "A-"
            case .bPositive:
                bloodTypeText = "B+"
            case .bNegative:
                bloodTypeText = "B-"
            case .abPositive:
                bloodTypeText = "AB+"
            case .abNegative:
                bloodTypeText = "AB-"
            case .oPositive:
                bloodTypeText = "O+"
            case .oNegative:
                bloodTypeText = "O-"
            default:
                break
            }
        }
        
        return bloodTypeText
    }
    
    func getReadable(biologicalSex: HKBiologicalSexObject?) -> String {
        var readeableBiologicalSex: String = "Other"
        if let sex = biologicalSex?.biologicalSex {
            switch sex {
            case .notSet:
                readeableBiologicalSex = "Not Defined"
            case .female:
                readeableBiologicalSex = "Female"
            case .male:
                readeableBiologicalSex = "Male"
            case .other:
                readeableBiologicalSex = "Other"
            @unknown default:
                readeableBiologicalSex = "Other"
            }
        }
        
        return readeableBiologicalSex
    }
    
    func authorizeHealthKit() {
        let healthKitTypesToRead: Set<HKObjectType> = [
            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!,
            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.bloodType)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!,
            HKObjectType.characteristicType(forIdentifier: .biologicalSex)!,
            HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!,
            HKObjectType.quantityType(forIdentifier: .height)!,
            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatTotal)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatSaturated)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCholesterol)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFiber)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietarySugar)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryProtein)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCalcium)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryIron)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryPotassium)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietarySodium)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryVitaminA)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryVitaminC)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryVitaminD)!,
            HKObjectType.workoutType(),
            HKObjectType.activitySummaryType()
        ]
        
        let healthKitTypesToWrite: Set<HKSampleType> = []
        
        if !HKHealthStore.isHealthDataAvailable() {
            print("Error ocurred")
        }
        
        healthKitStore.requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { (sucess, error) -> Void in
            if sucess {
                //NotificationCenter.default.post(name: NSNotification.Name("healthKitAuth"), object: nil)
            }
            
        }
    }
    
    func weightRecords(from: Date, to: Date, patient: Patient) {
        let weightType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        let query = HKSampleQuery(sampleType: weightType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
            if let result = results?.last as? HKQuantitySample {
                if result.startDate >= from && result.endDate <= to {
                    DispatchQueue.main.async(execute: { () -> Void in
                        let grams = result.quantity.doubleValue(for: HKUnit.gram())
                        let weight = Weight(weight: grams, startDate: result.startDate, endDate: result.endDate)
                        let primaryKey = "\(result.startDate)\(result.endDate)"
                        if self.realm?.object(ofType: Weight.self, forPrimaryKey: primaryKey) == nil {
                            do {
                                try? self.realm?.write {
                                    patient.weightRecords.append(weight)
                                }
                            }
                        }
                    })
                }
            }
        }
        
        healthKitStore.execute(query)
    }
    
    
    func dietaryInformation(from: Date, to: Date, patient: Patient) {
        
        guard let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed) else {
            fatalError("*** This method should never fail ***")
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: from, end: to, options: [])
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
            query, results, error in
            
            guard let samples = results as? [HKQuantitySample] else { return }
            
            DispatchQueue.main.async {
                for sample in samples {
                    guard let foodName =
                        sample.metadata?[HKMetadataKeyFoodType] as? String else { break }
                    let kilocalories = sample.quantity.doubleValue(for: HKUnit.kilocalorie())
                    let food = Food(kilocalories: kilocalories, name: foodName, startDate: sample.startDate, endDate: sample.endDate)
                    let primaryKey = "\(sample.startDate)\(sample.endDate)"
                    if self.realm?.object(ofType: Food.self, forPrimaryKey: primaryKey) == nil {
                        do {
                            try? self.realm?.write {
                                patient.ingestedFoods.append(food)
                            }
                        }
                    }
                }
            }
        }
        
        healthKitStore.execute(query)
    }
    
    func heightRecords(from: Date, to: Date, patient: Patient) {
        let heightType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
        let query = HKSampleQuery(sampleType: heightType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
            if let result = results?.last as? HKQuantitySample {
                if result.startDate >= from && result.endDate <= to {
                    DispatchQueue.main.async(execute: { () -> Void in
                        let meters = result.quantity.doubleValue(for: HKUnit.meter())
                        let height = Height(height: meters, startDate: result.startDate, endDate: result.endDate)
                        let primaryKey = "\(result.startDate)\(result.endDate)"
                        if self.realm?.object(ofType: Height.self, forPrimaryKey: primaryKey) == nil {
                            do {
                                try? self.realm?.write {
                                    patient.heightRecords.append(height)
                                }
                            }
                        }
                    })
                }
            } else {
                print("OOPS didnt get height \nResults => \(String(describing: results)), error => \(String(describing: error))")
            }
        }
        
        healthKitStore.execute(query)
    }
    
    func getSleepAnalysis(from: Date, to: Date, patient: Patient) {
        if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: 30, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) -> Void in
                if error != nil {
                    return
                }
                if let result = tmpResult {
                    for item in result {
                        if let sample = item as? HKCategorySample {
                            if sample.startDate >= from && sample.endDate <= to {
                                DispatchQueue.main.async(execute: { () -> Void in
                                    let sleepAnalisys = SleepAnalisys(startDate: sample.startDate, endDate: sample.endDate)
                                    let primaryKey = "\(sample.startDate)\(sample.endDate)"
                                    if self.realm?.object(ofType: SleepAnalisys.self, forPrimaryKey: primaryKey) == nil {
                                        do {
                                            try? self.realm?.write {
                                                patient.sleepRecords.append(sleepAnalisys)
                                            }
                                        }
                                    }
                                })
                            }
                        }
                    }
                }
            }
            healthKitStore.execute(query)
        }
    }
    
    func getHearthRate(from: Date, to: Date, patient: Patient) {
        let hearthRateSample = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)
        let query = HKSampleQuery(sampleType: hearthRateSample!, predicate: .none, limit: 0, sortDescriptors: nil) { query, results, error in
            if results?.count ?? 0 > 0 {
                for result in results as! [HKQuantitySample] {
                    if result.startDate >= from && result.endDate <= to {
                        DispatchQueue.main.async(execute: { () -> Void in
                            let formatedResult = self.getFormated(sample: result, forValue: HealthValue.hearth)
                            let hearthRecord = HearthRecord(bpm: formatedResult as! Int, startDate: result.startDate, endDate: result.endDate)
                            let primaryKey = "\(result.startDate)\(result.endDate)"
                            if self.realm?.object(ofType: HearthRecord.self, forPrimaryKey: primaryKey) == nil {
                                do {
                                    try? self.realm?.write {
                                        patient.hearthRecords.append(hearthRecord)
                                    }
                                }
                            }
                        })
                    }
                }
            }
        }
        healthKitStore.execute(query)
    }
    
    func getActiveEnergy(patient: Patient) {
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .year, value: -100, to: endDate)
        
        let energySampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        
        let query = HKSampleQuery(sampleType: energySampleType!, predicate: predicate, limit: 0, sortDescriptors: nil, resultsHandler: {
            (query, results, error) in
            if results == nil || results?.count ?? 0 <= 0 {
                print("There was an error running the query => \(String(describing: error))")
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                if results?.count ?? 0 > 0 {
                    for activity in results as! [HKQuantitySample] {
                        let totalActiveEnergy = activity.quantity.doubleValue(for: HKUnit.kilocalorie())
                        let activity = WorkoutRecord(startDate: activity.startDate, endDate: activity.endDate, caloriesBurned: totalActiveEnergy)
                        let primaryKey = "\(activity.startDate)\(activity.endDate)"
                        if self.realm?.object(ofType: WorkoutRecord.self, forPrimaryKey: primaryKey) == nil {
                            do {
                                try? self.realm?.write {
                                    patient.workoutRecords.append(activity)
                                }
                            }
                        }
                    }
                }
            })
        })
        healthKitStore.execute(query)
    }
    
    func getStepsCount(forSpecificDate: Date, completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let (start, end) = getWholeDate(date: forSpecificDate)
        
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        
        healthKitStore.execute(query)
    }
    
    func getWholeDate(date: Date) -> (startDate:Date, endDate: Date) {
        var startDate = date
        var length = TimeInterval()
        _ = Calendar.current.dateInterval(of: .day, start: &startDate, interval: &length, for: startDate)
        let endDate:Date = startDate.addingTimeInterval(length)
        return (startDate, endDate)
    }
    
    func getFormated(measure: Double, on: MeasurementUnit) -> String {
        var formatedMeasure = ""
        var convertedUnit = 0.0
        switch on {
        case .feet:
            convertedUnit = measure * 0.032808
            formatedMeasure = "\(convertedUnit.rounded()) ft"
            break
        case .kilogram:
            convertedUnit = measure / 1000
            formatedMeasure = "\(convertedUnit.rounded()) kg"
        case .meter:
            if measure < 100 {
                formatedMeasure = "\(measure) Mt"
            } else {
                convertedUnit = measure / 100
                formatedMeasure = "\(convertedUnit) Mt"
            }
        case .pound:
            convertedUnit = measure / 453.592
            formatedMeasure = "\(convertedUnit.rounded()) lb"
        }
        return formatedMeasure
    }
    
    
    func getFormated(sample: HKQuantitySample, forValue: HealthValue) -> AnyObject {
        var toFormat = "\(sample.quantity)"
        switch forValue {
        case .hearth:
            toFormat = toFormat.replacingOccurrences(of: " count/min", with: "")
            if let formated = Int(toFormat) {
                return formated as AnyObject
            } else {
                return 0.0 as AnyObject
            }
        case .height:
            toFormat = toFormat.replacingOccurrences(of: " cm", with: "")
            toFormat = toFormat.replacingOccurrences(of: " m", with: "")
            if let formated = Double(toFormat) {
                return formated as AnyObject
            } else {
                return 0.0 as AnyObject
            }
        case .weight:
            if toFormat.contains("lb") {
                toFormat = toFormat.replacingOccurrences(of: " lb", with: "")
                if let formated = Double(toFormat) {
                    return formated as AnyObject
                } else {
                    return 0.0 as AnyObject
                }
            } else if toFormat.contains("g") {
                toFormat = toFormat.replacingOccurrences(of: " g", with: "")
                if let formated = Double(toFormat) {
                    return formated as AnyObject
                } else {
                    return 0.0 as AnyObject
                }
            } else {
                if (Double(toFormat) != nil) {
                    return toFormat as AnyObject
                } else {
                    return 0.0 as AnyObject
                }
            }
            
        }
    }
    
}
