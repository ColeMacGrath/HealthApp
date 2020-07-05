//
//  HealthKitService.swift
//  HealthApp
//
//  Created by Moisés on 04/07/20.
//  Copyright © 2020 Moisés Córdova. All rights reserved.
//

import Foundation
import HealthKit

enum HealthKitError: Error {
    case deviceNotCompatible(description: String?)
    case notAuthorized(description: String)
    case healthTypeNotAvailable
    case genericError
}

class HealthKitService {
    
    private static let _shared = HealthKitService()
    private let healthKitStore = HKHealthStore()
    
    static var shared: HealthKitService {
        return self._shared
    }
    
    private var isHealthKitAvailable: Bool {
        guard HKHealthStore.isHealthDataAvailable() else { return false }
        return true
    }
    
    func requestDataTypes(handler: @escaping (_ data: HealthKitError?) -> Void) {
        if self.isHealthKitAvailable {
            guard let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
            let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType),
            let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
            let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
            let height = HKObjectType.quantityType(forIdentifier: .height),
            let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
            let activeEnergyBurned = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
                handler(HealthKitError.healthTypeNotAvailable)
                return
            }
            
            let healthKitTypesToRead: Set<HKObjectType> = [dateOfBirth, bloodType, biologicalSex, bodyMassIndex, height, bodyMass, activeEnergyBurned, .workoutType()]
            
            HKHealthStore().requestAuthorization(toShare: nil, read: healthKitTypesToRead) { (success, error) in
                if error != nil {
                    handler(HealthKitError.genericError)
                    return
                }
                handler(nil)
            }
        } else {
            handler(HealthKitError.deviceNotCompatible(description: "Device not compatible with HealthKit"))
            return
        }
    }
    
    func getBiologicalSex(handler: @escaping (_ biologicalSex: HKBiologicalSexObject?, _ error: Error?) -> Void) {
        do {
            let biologicalSex = try self.healthKitStore.biologicalSex()
            handler(biologicalSex, nil)
        } catch {
            handler(nil, error)
        }
    }
    
}
