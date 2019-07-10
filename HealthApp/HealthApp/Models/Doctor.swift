//
//  Doctor.swift
//  HealthApp
//
//  Created by Moisés Córdova on 7/9/19.
//  Copyright © 2019 Moisés Córdova. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Doctor: Object {
    @objc private(set) dynamic var _username: String = ""
    @objc private(set) dynamic var _direction: String = ""
    @objc private(set) dynamic var _email: String = ""
    @objc private(set) dynamic var _phone: String = ""
    @objc private(set) dynamic var _uid: String = ""
    @objc private(set) dynamic var _specialty: String = ""
    @objc private(set) dynamic var _profileImage: Data?
    //@objc private(set) dynamic var _appointments: [Appointment]
    
    
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
    
    /*var appointments: [Appointment] {
        set {
            _appointments = newValue
        }
        get {
            return _appointments
        }
    }*/
    
    var profilePicture: UIImage {
        set {
            _profileImage = newValue.pngData()!
        } get {
            return UIImage(data: _profileImage!)!
        }
    }
    
    convenience init(uid: String, firstName: String, lastName: String, direction: String, email: String, phone: String, specialty: String, profilePicture: UIImage) {
        self.init()
        _uid = uid
        _username = "\(firstName) \(lastName)"
        _direction = direction
        _email = email
        _phone = phone
        _profileImage = profilePicture.pngData()!
        //_appointments = []
        _specialty = specialty
    }
    
    /*func add(appointment: Appointment) {
        _appointments.append(appointment)
    }*/
    
}
