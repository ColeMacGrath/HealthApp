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
    @objc private(set) dynamic var _firstName: String = ""
    @objc private(set) dynamic var _lastName: String = ""
    @objc private(set) dynamic var _direction: String = ""
    @objc private(set) dynamic var _email: String = ""
    @objc private(set) dynamic var _phone: String = ""
    @objc private(set) dynamic var _uid: String = ""
    @objc private(set) dynamic var _specialty: String = ""
    @objc private(set) dynamic var _profileImage: Data?
    //@objc private(set) dynamic var _appointments: [Appointment]
    
    override static func primaryKey() -> String? {
        return "_uid"
    }
    
    
    var uid: String { return _uid }
    var direction: String {
        set {
            _direction = newValue
        }
        get {
          return _direction
        }
    }
    var email:  String {
        set {
            _email = newValue
        }
        get {
          return _email
        }
    }
    var phone: String {
        set {
            _phone = newValue
        }
        get {
            return _phone
        }
    }
    
    var specialty: String {
        set {
            _specialty = newValue
        }
        get {
            return _specialty
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
    
    var lastName: String {
        set {
            _lastName = newValue
        }
        get {
            _lastName
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
    
    var profilePicture: UIImage? {
        guard let profileData = _profileImage else { return nil }
        if let profileImage = UIImage(data: profileData) {
            return profileImage
        }
        return nil
    }
    
    var dataProfileImage: Data? {
        set {
            _profileImage = newValue
        }
        get {
            return _profileImage
        }
    }
    
    convenience init(uid: String, firstName: String, lastName: String, direction: String, email: String, phone: String, specialty: String, profilePicture: Data?) {
        self.init()
        _uid = uid
        _firstName = firstName
        _lastName = lastName
        _direction = direction
        _email = email
        _phone = phone
        _profileImage = profilePicture
        //_appointments = []
        _specialty = specialty
    }
    
    /*func add(appointment: Appointment) {
        _appointments.append(appointment)
    }*/
    
}
