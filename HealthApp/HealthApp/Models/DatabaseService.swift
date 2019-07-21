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
    
    func create(appointment: Appointment) {
        let newAppointment: Dictionary<String, AnyObject> = [
            "patientUID": appointment.patientUid as AnyObject,
            "doctorUID": appointment.doctorUid as AnyObject,
            "startDate": appointment.startDate.iso8601 as AnyObject,
            "endDate": appointment.endDate.iso8601 as AnyObject,
            "notes": appointment.notes as AnyObject
        ]
        self.patientsRef.child(appointment.patientUid).child("appointments").child(appointment.id).setValue(appointment.id)
        self.doctorsRef.child(appointment.doctorUid).child("appointments").child(appointment.id).setValue(appointment.id)
        self.appointmentsRef.child(appointment.id).setValue(newAppointment)
    }
    
    func savePatient(patient: Patient) {
       let profile: Dictionary<String, AnyObject> = ["firstName": patient.firstName as AnyObject, "lastName": patient.lastName as AnyObject, "email": patient.email as AnyObject]
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
    
    func addDoctor(doctorUID: String, patientUID: String) {
        self.patientsRef.child(patientUID).child("doctors").child(doctorUID).setValue(doctorUID)
            self.addPatient(doctorUID: doctorUID, userUID: patientUID)
    }
    
    func addPatient(doctorUID: String, userUID: String) {
        self.doctorsRef.child(doctorUID).child("patients").child(userUID).setValue(userUID)
    }
    
    func removeDoctorWith(uid: String, patientUID: String) {
        self.patientsRef.child(patientUID).child("doctors").child(uid).child("removed").setValue(true)
        self.doctorsRef.child(uid).child("patients").child(patientUID).child("removed").setValue(true)
    }
    
    func remove(appointmentUID: String, patientUID: String, doctorUID: String) {
        self.appointmentsRef.child(appointmentUID).removeValue()
        self.patientsRef.child(patientUID).child("appointments").child(appointmentUID).child("removed").setValue(true)
        self.doctorsRef.child(doctorUID).child("appointments").child(appointmentUID).child("removed").setValue(true)
    }
    
    func saveBasicInfoInFirebase(patient: Patient) {
        let firstName = patient.firstName
        let lastName = patient.lastName
        let email = patient.email
        let dictionary: [String: AnyObject] = [
            "firstName": firstName as AnyObject,
            "lastName": lastName as AnyObject,
            "email": email as AnyObject
        ]
        self.mainRef.child(FIR_CHILD_PATIENTS).child("\(patient.uid)/profile/basicData/").setValue(dictionary)
    }
    
    func saveHealthDataInFirebase(patient: Patient) {
        let age = patient.age
        let bloodType = patient.bloodType
        let biologicalSex = patient.biologicalSex
        
        let dictionary: [String: AnyObject] = [
                "bloodType": bloodType as AnyObject,
                "biologicalSex": biologicalSex as AnyObject,
                "age": age as AnyObject
        ]
        self.mainRef.child(FIR_CHILD_PATIENTS).child("\(patient.uid)/profile/healthData/").setValue(dictionary)
        
        for heightRecord in patient.heightRecords {
            self.mainRef.child("\(FIR_CHILD_PATIENTS)/\(patient.uid)/heightRecords/").child(heightRecord.startDate.iso8601).setValue(heightRecord.height)
        }
        
        for weightRecord in patient.weightRecords {
            self.mainRef.child("\(FIR_CHILD_PATIENTS)/\(patient.uid)/weightRecords/").child(weightRecord.startDate.iso8601).setValue(weightRecord.weight)
        }
        
        for sleepRecord in patient.sleepRecords {
            let sleepDict: [String: AnyObject] = [
                "startDate": sleepRecord.startDate.iso8601 as AnyObject,
                "endDate": sleepRecord.endDate.iso8601 as AnyObject
            ]
            self.mainRef.child("\(FIR_CHILD_PATIENTS)/\(patient.uid)/sleepRecords/").child(sleepRecord.startDate.iso8601).setValue(sleepDict)
        }
        
        for workout in patient.workoutRecords {
            self.mainRef.child("\(FIR_CHILD_PATIENTS)/\(patient.uid)/workoutRecords/").child(workout.startDate.iso8601).setValue(workout.calories)
        }
        
        for foodRecord in patient.ingestedFoods {
            let foodDict: [String: AnyObject] = [
                "name": foodRecord.name as AnyObject,
                "calories": "\(foodRecord.kilocalories)" as AnyObject
            ]
            self.mainRef.child("\(FIR_CHILD_PATIENTS)/\(patient.uid)/ingestedFoodRecords/").child(foodRecord.startDate.iso8601).setValue(foodDict)
        }
        
        for hearthRecord in patient.hearthRecords {
            self.mainRef.child("\(FIR_CHILD_PATIENTS)/\(patient.uid)/hearthRecords/").child(hearthRecord.startDate.iso8601).setValue(hearthRecord.bpm)
        }
    }
}

