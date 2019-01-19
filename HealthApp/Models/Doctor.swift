import Foundation
import UIKit

class Doctor {
    private var _username: String
    private var _direction: String
    private var _email: String
    private var _phone: String
    private var _uid: String
    private var _profileImage: UIImage
    private var _appointments: [Appointment]
    private var _specialty: String
    
    var uid:        String { return _uid }
    var username:   String { return _username }
    var direction:  String { return _direction }
    var email:      String { return _email }
    var phone:      String { return _phone }
    
    var specialty: String {
        set {
            _specialty = newValue
        }
        get {
            return _specialty
        }
    }
    
    var appointments: [Appointment] {
        set {
            _appointments = newValue
        }
        get {
            return _appointments
        }
    }
    
    var profilePicture: UIImage {
        set {
            _profileImage = newValue
        } get {
             return _profileImage
        }
    }
    
    init(uid: String, firstName: String, lastName: String, direction: String, email: String, phone: String, specialty: String, profilePicture: UIImage) {
        _uid = uid
        _username = "\(firstName) \(lastName)"
        _direction = direction
        _email = email
        _phone = phone
        _profileImage = profilePicture
        _appointments = []
        _specialty = specialty
    }
    
    func add(appointment: Appointment) {
        _appointments.append(appointment)
    }
    
}
