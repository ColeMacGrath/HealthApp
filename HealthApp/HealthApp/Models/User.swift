//
//  User.swift
//  HealthApp
//
//  Created by Moisés on 04/07/20.
//  Copyright © 2020 Moisés Córdova. All rights reserved.
//

import Foundation

class User {
    private var _firstName: String
    private var _lastName: String
    private var _age: Int?
    private var _bloodType: String?
    private var _birthDay: Date?
    private var _biologicalSex: String?
    
    init() {
        self._firstName = "First"
        self._lastName = "Last"
    }
    
    var firstName: String {
        set { self._firstName = newValue    }
        get { return self._firstName        }
    }
    
    var lastName: String {
        set { self._lastName = newValue     }
        get { return self._lastName         }
    }
    
    var fullName: String { return "\(self._firstName) \(self._lastName)"}
    
    var biologicalSex: String? {
        set { self._biologicalSex = newValue    }
        get { return self._biologicalSex        }
    }
    
    var birthday: Date? {
        set { self._birthDay = newValue }
        get { return self._birthDay     }
    }
    
    var bloodType: String? {
        set { self._bloodType = newValue    }
        get { return self._bloodType        }
    }
}
