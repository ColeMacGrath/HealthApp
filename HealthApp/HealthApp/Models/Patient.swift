//
//  Patient.swift
//  HealthApp
//
//  Created by Moisés Córdova on 7/9/19.
//  Copyright © 2019 Moisés Córdova. All rights reserved.
//

import Foundation
import RealmSwift

class Patient: Object {
    @objc private(set) dynamic var _uid: String = ""
    @objc private(set) dynamic var _steps: Int = 0
    @objc private(set) dynamic var _age: Int = 0
    @objc private(set) dynamic var _username: String = ""
    @objc private(set) dynamic var _firstName: String = ""
    @objc private(set) dynamic var _lastName: String = ""
    @objc private(set) dynamic var _bloodType: String = ""
    @objc private(set) dynamic var _biologialSex: String = ""
    @objc private(set) dynamic var _email: String = ""
    @objc private(set) dynamic var _profilePicture: Data?
    var _heightRecords = List<Height>()
    var _weightRecords = List<Weight>()
    var _sleepRecords = List<SleepAnalisys>()
    var _workoutRecords = List<WorkoutRecord>()
    var _hearthRecords = List<HearthRecord>()
    var _ingestedFoods = List<Food>()
    var _stepsRecords = List<StepRecord>()
    
    override static func primaryKey() -> String? {
        return "_uid"
    }
    
    convenience init(uid: String) {
        self.init()
        self._uid = uid
        self._steps = 0
        self._age = 0
        self._username = ""
        self._firstName = ""
        self._lastName = ""
        self._bloodType = ""
        self._biologialSex = ""
        self._email = ""
    }
    
    var username:       String              { return "\(_firstName) \(_lastName)" }
    var heightRecords:  List<Height>        { return _heightRecords }
    var weightRecords:  List<Weight>        { return _weightRecords }
    var hearthRecords:  List<HearthRecord>  { return _hearthRecords }
    var workoutRecords: List<WorkoutRecord> { return _workoutRecords}
    var sleepRecords:   List<SleepAnalisys> { return _sleepRecords }
    var ingestedFoods:  List<Food>          { return _ingestedFoods }
    var stepsRecords:   List<StepRecord>    { return _stepsRecords }
    
    var uid: String {
        set {
            _uid = newValue
        }
        get {
            return _uid
        }
    }

    var email: String {
        set {
            _email = newValue
        }
        get {
            return _email
        }
    }
    
    var firstName: String {
        set {
            _firstName = newValue
        }
        get {
            return _firstName
        }
    }
    
    var profilePicture: UIImage {
        set {
            _profilePicture = newValue.pngData()
        }
        get {
            return UIImage(data: _profilePicture!)!
        }
    }
    
    var lastName: String {
        set {
            _lastName = newValue
        }
        get {
            return _lastName
        }
    }
    
    var bloodType: String {
        set {
            _bloodType = newValue
        }
        get {
            return _bloodType
        }
    }
    
    var age: Int {
        set {
            _age = newValue
        }
        get {
            return _age
        }
    }
    var biologicalSex: String {
        set{
            _biologialSex = newValue
        }
        get {
            return _biologialSex
        }
    }
    
    var steps: Int {
        set {
            _steps = newValue
        }
        get {
            return _steps
        }
    }
    
    /*func getAppointments(of doctor: Doctor) -> [Appointment] {
        let filteredAppointments = _appointments.filter( { doctor.uid.contains($0.doctorUid) } )
        return filteredAppointments
    }*/
    
    /*func add(appointment: Appointment) {
        _appointments.append(appointment)
    }*/
    
    func add(hearthRecord: HearthRecord) {
        _hearthRecords.append(hearthRecord)
    }
    
    func add(sleepRecord: SleepAnalisys) {
        _sleepRecords.append(sleepRecord)
    }
    
    func add(weightRecord: Weight) {
        _weightRecords.append(weightRecord)
    }
    func add(heightRecord: Height) {
        _heightRecords.append(heightRecord)
    }
    
    func add(workoutRecord: WorkoutRecord) {
        _workoutRecords.append(workoutRecord)
    }
    
    func saveHealthInfoInFirebase() {
        DatabaseService.shared.savePatientInfoInFirebase(patient: self)
    }
}
