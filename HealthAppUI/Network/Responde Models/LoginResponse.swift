//
//  LoginResponse.swift
//  HealthAppUI
//
//  Created by Moisés Córdova on 2024-11-30.
//

import Foundation

struct LoginResponse: Codable {
    var id: Int
    var sessionToken: String
    var userType: String
    var username: String
}
