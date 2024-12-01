//
//  HTTPConstants.swift
//  HealthAppUI
//
//  Created by Moisés Córdova on 2024-11-30.
//

import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE, PATCH
}

enum HTTPStatusCode: Int {
    case ok = 200
    case created = 201
    case badRequest = 400
    case unauthorized = 401
    case appUnavailable = 999
    case unknown
    
    init(rawValue: Int) {
        switch rawValue {
        case 200: self = .ok
        case 201: self = .created
        case 400: self = .badRequest
        case 401: self = .unauthorized
        case 999: self = .appUnavailable
        default: self = .unknown
        }
    }
}
