//
//  User.swift
//  HealthApp
//
//  Created by Moisés on 04/07/20.
//  Copyright © 2020 Moisés Córdova. All rights reserved.
//

import Foundation

class User {
    var _firstName: String
    var _lastName: String
    var _age: Int?
    var _bloodType: String?
    var _birthDay: Date?
    var _biologicalSex: String?
    
    init() {
        self._firstName = "First"
        self._lastName = "Last"
    }
}
