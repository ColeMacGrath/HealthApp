//
//  DatabaseService.swift
//  HealthApp
//
//  Created by Moisés Córdova on 7/17/19.
//  Copyright © 2019 Moisés Córdova. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

let FIR_CHILD_PATIENTS = "patients"
let FIR_CHILD_DOCTORS = "doctors"
let FIR_CHILD_APPOINTMENTS = "appointments"
class DatabaseService {
    private static let _shared = DatabaseService()
    
    static var shared: DatabaseService {
        return _shared
    }
    
    var mainRef: DatabaseReference {
        return Database.database().reference()
    }
    
    var patientsRef: DatabaseReference {
        return mainRef.child(FIR_CHILD_PATIENTS)
    }
    
    var doctorsRef: DatabaseReference {
        return mainRef.child(FIR_CHILD_DOCTORS)
    }
    
    var appointmentsRef: DatabaseReference {
        return mainRef.child(FIR_CHILD_APPOINTMENTS)
    }
    
    var mainStorageRef: StorageReference {
        return Storage.storage().reference(forURL: "gs://healthapp-f49f3.appspot.com")
    }
    
    var imageStorageRef: StorageReference {
        return mainStorageRef.child("images")
    }
    
    func savePatient(patient: Patient) {
       let profile: Dictionary<String, AnyObject> = ["firstName": patient.firstName as AnyObject, "lastName": patient.lastName as AnyObject, "age": patient.age as AnyObject, "email": patient.email as AnyObject]
        self.mainRef.child(FIR_CHILD_PATIENTS).child(patient.uid).child("profile").setValue(profile)
    }
    
    func savePictureRef(uid: String, url: URL) {
        let patientRef: Dictionary<String, AnyObject> = ["profilePictureURL": url.absoluteString as AnyObject]
        self.mainRef.child(FIR_CHILD_PATIENTS).child(uid).child("profile").child("profilePicture").setValue(patientRef)
    }
    
    func saveProfilePictureRef(patientUID: String, url: URL) {
        let patientRef: Dictionary<String, AnyObject> = ["profilePicture": url.absoluteString as AnyObject]
        self.mainRef.child(FIR_CHILD_PATIENTS).child(patientUID).child("profileURL").setValue(patientRef)
    }
    
    func savePatientInfoInFirebase(patient: Patient) {
        let age = patient.age
        let firstName = patient.firstName
        let lastName = patient.lastName
        let bloodType = patient.bloodType
        let biologicalSex = patient.biologicalSex
        let email = patient.email
        
        let dictionary: [String: AnyObject] = [
            "profile": [
                "firstName": firstName as AnyObject,
                "lastName": lastName as AnyObject,
                "bloodType": bloodType as AnyObject,
                "biologicalSex": biologicalSex as AnyObject,
                "email": email as AnyObject,
                "age": age as AnyObject
            ] as AnyObject
        ]
        self.mainRef.child(FIR_CHILD_PATIENTS).child(patient.uid).setValue(dictionary)
        
        for heightRecord in patient.heightRecords {
            self.mainRef.child("\(FIR_CHILD_PATIENTS)/\(patient.uid)/heightRecords/").child("\(heightRecord.startDate)").setValue(heightRecord.height)
        }
        
        for weightRecord in patient.weightRecords {
            self.mainRef.child("\(FIR_CHILD_PATIENTS)/\(patient.uid)/weightRecords/").child("\(weightRecord.startDate)").setValue(weightRecord.weight)
        }
        
        for sleepRecord in patient.sleepRecords {
            let sleepDict: [String: AnyObject] = [
                "startDate": "\(sleepRecord.startDate)" as AnyObject,
                "endDate": "\(sleepRecord.endDate)" as AnyObject
            ]
            self.mainRef.child("\(FIR_CHILD_PATIENTS)/\(patient.uid)/sleepRecords/").child("\(sleepRecord.startDate)").setValue(sleepDict)
        }
        
        for workout in patient.workoutRecords {
            self.mainRef.child("\(FIR_CHILD_PATIENTS)/\(patient.uid)/workoutRecords/").child("\(workout.startDate)").setValue(workout.calories)
        }
        
        for foodRecord in patient.ingestedFoods {
            let foodDict: [String: AnyObject] = [
                "name": foodRecord.name as AnyObject,
                "calories": "\(foodRecord.kilocalories)" as AnyObject
            ]
            self.mainRef.child("\(FIR_CHILD_PATIENTS)/\(patient.uid)/ingestedFoodRecords/").child("\(foodRecord.startDate)").setValue(foodDict)
        }
        
        for hearthRecord in patient.hearthRecords {
            self.mainRef.child("\(FIR_CHILD_PATIENTS)/\(patient.uid)/hearthRecords/").child("\(hearthRecord.startDate)").setValue(hearthRecord.bpm)
        }
    }
}

