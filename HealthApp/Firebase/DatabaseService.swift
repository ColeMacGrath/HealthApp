import Foundation
import FirebaseDatabase
import FirebaseAuth

let FIR_CHILD_DOCTORS = "doctors"
let FIR_CHILD_USERS = "users"
let FIR_CHILD_APPOINTMENT = "appointments"
let FIR_CHILD_APPOINTMENT_REMOVE = "appointmentsToRemove"

enum UserType: Int {
    case patient = 0
    case doctor = 1
    case other = 3
}

class DatabaseService {
    
    private static let _shared = DatabaseService()
    
    static var shared: DatabaseService {
        return _shared
    }
    
    var mainRef: DatabaseReference {
        return Database.database().reference()
    }
    
    var doctorsRef: DatabaseReference {
        return mainRef.child(FIR_CHILD_DOCTORS)
    }
    
    var usersRef: DatabaseReference {
        return mainRef.child(FIR_CHILD_USERS)
    }
    
    var appointmentsRef: DatabaseReference {
        return mainRef.child(FIR_CHILD_APPOINTMENT)
    }
    
    private func addUserTo(doctor: Doctor, useruid: String) {
        let doctorId = doctor.uid
        self.mainRef.child("\(FIR_CHILD_DOCTORS)/\(doctorId)/patients/\(useruid)").setValue(useruid)
    }
    
    private func addUserTo(doctor withUid: String, userId: String) {
        self.mainRef.child("\(FIR_CHILD_DOCTORS)/\(withUid)/patients/\(userId)").setValue(userId)
    }
    
    private func add(appointment: Appointment, doctorUid: String, patientUid: String) {
        let appointmentId = appointment.id
        self.mainRef.child("\(FIR_CHILD_DOCTORS)/\(doctorUid)/\(FIR_CHILD_APPOINTMENT)/\(appointmentId)").setValue(appointmentId)
        self.mainRef.child("\(FIR_CHILD_USERS)/\(patientUid)/\(FIR_CHILD_APPOINTMENT)/\(appointmentId)").setValue(appointmentId)
    }
    
    func addDoctor(doctor: Doctor) {
        let doctorId = doctor.uid
        if let userId = Auth.auth().currentUser?.uid {
            self.mainRef.child("\(FIR_CHILD_USERS)/\(userId)/doctors/\(doctorId)").setValue(doctorId)
            self.addUserTo(doctor: doctor, useruid: userId)
        }
    }
    
    func addDoctor(with uid: String) {
        if let userId = Auth.auth().currentUser?.uid {
            self.mainRef.child("\(FIR_CHILD_USERS)/\(userId)/doctors/\(uid)").setValue(uid)
            self.addUserTo(doctor: uid, userId: userId)
        }
    }
    
    func addInfoFromHealthKit(patient: Patient) {
        
        let profile: Dictionary<String, AnyObject> = ["firstName": patient.firstName as AnyObject, "lastName": patient.lastName as AnyObject, "bloodType": patient.bloodType as AnyObject, "age": String(patient.age) as AnyObject, "biologicalSex": patient.biologicalSex as AnyObject]
        
        if let userId = Auth.auth().currentUser?.uid {
            self.mainRef.child("\(FIR_CHILD_USERS)").child(userId).child("profile").setValue(profile)
            
            for hearthRecord in patient.hearthRecords {
                self.mainRef.child("\(FIR_CHILD_USERS)/\(userId)/hearthRecords/").child("\(hearthRecord.startDate)").setValue(String(hearthRecord.bpm))
            }
            
            for heightRecord in patient.heightRecords {
                self.mainRef.child("\(FIR_CHILD_USERS)/\(userId)/heightRecords/").child("\(heightRecord.startDate)").setValue("\(heightRecord.height)")
            }
            
            for weightRecord in patient.weightRecords {
                self.mainRef.child("\(FIR_CHILD_USERS)/\(userId)/weightRecords/").child("\(weightRecord.startDate)").setValue("\(weightRecord.weight)")
            }
            
            for sleepRecord in patient.sleepRecords {
                self.mainRef.child("\(FIR_CHILD_USERS)/\(userId)/sleepRecords/").child("\(sleepRecord.startDate)").setValue(sleepRecord.hoursSleeping)
            }
            
            for workoutRecord in patient.workoutRecords {
                 let information: Dictionary<String, AnyObject> = ["time" : workoutRecord.time as AnyObject, "calories": "\(workoutRecord.calories)" as AnyObject, "startDate": "\(workoutRecord.startDate)" as AnyObject, "endDate": "\(workoutRecord.endDate)" as AnyObject]
                self.mainRef.child("\(FIR_CHILD_USERS)/\(userId)/workoutsRecords/").child("\(workoutRecord.startDate)").setValue(information)
            }
        }
    }
    
    func saveUser(uid: String) {
        let profile: Dictionary<String, AnyObject> = ["firstName": "" as AnyObject, "secondName": "" as AnyObject, "gender": "" as AnyObject]
        self.mainRef.child(FIR_CHILD_USERS).child(uid).child("profile").setValue(profile)
    }
    
    func create(appointment: Appointment) {
        let firebaseAppointment: Dictionary<String, AnyObject> = ["doctorId": appointment.doctorUid as AnyObject, "patientId": appointment.patientUid as AnyObject, "startDate": "\(appointment.startDate)" as AnyObject, "endDate": "\(appointment.endDate)" as AnyObject, "notes": appointment.notes as AnyObject, "patientLocalIdentifier": appointment.localIdentifier as AnyObject, "doctorLocalIdentifier": appointment.doctorLocalIdentifier as AnyObject]
        self.mainRef.child("\(FIR_CHILD_APPOINTMENT)").child(appointment.id).setValue(firebaseAppointment)
        self.add(appointment: appointment, doctorUid: appointment.doctorUid, patientUid: appointment.patientUid)
    }
    
    func totalRemove(appointment: Appointment) {
        
        self.appointmentsRef.child(appointment.id).removeValue()
        
        self.mainRef.child("\(FIR_CHILD_USERS)/\(appointment.patientUid)/\(FIR_CHILD_APPOINTMENT)/\(appointment.id)").removeValue()
        
        self.mainRef.child("\(FIR_CHILD_DOCTORS)/\(appointment.doctorUid)/\(FIR_CHILD_APPOINTMENT)/\(appointment.id)").removeValue()
        
        self.removeReferenceOf(appointment: appointment, forUser: UserType.patient)
    }
    
    func remove(appointment: Appointment) {
        self.mainRef.child("\(FIR_CHILD_USERS)/\(appointment.patientUid)/\(FIR_CHILD_APPOINTMENT)/\(appointment.id)").removeValue()
        self.mainRef.child("\(FIR_CHILD_DOCTORS)/\(appointment.doctorUid)/\(FIR_CHILD_APPOINTMENT)/\(appointment.id)").removeValue()
        
        self.mainRef.child("\(FIR_CHILD_DOCTORS)/\(appointment.doctorUid)/appointmentsToRemove/\(appointment.id)").setValue(appointment.id)
    }
    
    func removeReferenceOf(appointment: Appointment, forUser: UserType) {
        if forUser == UserType.doctor {
            self.mainRef.child("\(FIR_CHILD_DOCTORS)/\(appointment.doctorUid)/appointmentsToRemove/\(appointment.id)").removeValue()
        } else {
            self.mainRef.child("\(FIR_CHILD_USERS)/\(appointment.patientUid)/appointmentsToRemove/\(appointment.id)").removeValue()
        }
    }
    
}
