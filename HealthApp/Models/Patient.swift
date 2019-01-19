import Foundation
import UIKit

class Patient {
    private var _uid: String
    private var _steps: Int
    private var _age: Int
    private var _username: String
    private var _firstName: String
    private var _lastName: String
    private var _bloodType: String
    private var _biologialSex: String
    private var _profilePicture: UIImage?
    private var _heightRecords: [Height]
    private var _weightRecords: [Weight]
    private var _sleepRecords: [SleepAnalisys]
    private var _workoutRecords: [WorkoutRecord]
    private var _hearthRecords: [HearthRecord]
    private var _appointments: [Appointment]
    private var _doctors: [Doctor]    
    
    init(uid: String) {
        _uid = uid
        _steps = 0
        _age = 0
        _username = ""
        _firstName = ""
        _lastName = ""
        _bloodType = ""
        _biologialSex = ""
        _heightRecords = []
        _weightRecords = []
        _sleepRecords = []
        _workoutRecords = []
        _hearthRecords = []
        _appointments = []
        _doctors = []
    }
    
    var uid:            String          { return _uid }
    var username:       String          { return "\(_firstName) \(_lastName)" }
    var heightRecords:  [Height]        { return _heightRecords }
    var weightRecords:  [Weight]        { return _weightRecords }
    var hearthRecords:  [HearthRecord]  { return _hearthRecords }
    var workoutRecords: [WorkoutRecord] { return _workoutRecords }
    var doctors:        [Doctor]        { return _doctors }
    var sleepRecords:   [SleepAnalisys] { return _sleepRecords }
    
    var appointments: [Appointment] {
        get {
            return _appointments
        }
        set {
            _appointments = newValue
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
            _profilePicture = newValue
        }
        get {
            return _profilePicture ?? UIImage(named: "profile-placeholder")!
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
    
    func getAppointments(of doctor: Doctor) -> [Appointment] {
        let filteredAppointments = _appointments.filter( { doctor.uid.contains($0.doctorUid) } )
        return filteredAppointments
    }
    
    func add(appointment: Appointment) {
        _appointments.append(appointment)
    }
    
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
}
