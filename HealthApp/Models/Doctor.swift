//
//  Doctor.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-11-03.
//

import Foundation
import SwiftUI

struct Doctor: Identifiable, Hashable {
    var id = UUID()
    var firstName: String
    var lastName: String
    var description: String
    var specialization: String
    var profilePicture: Image
    var lightBackgroundColor: Color
    var darkBackgroundColor: Color
    
    func backgroundColor(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? darkBackgroundColor : lightBackgroundColor
    }
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    // Custom hash function, excluding `Image` and `Color`
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(firstName)
        hasher.combine(lastName)
        hasher.combine(description)
        hasher.combine(specialization)
    }
    
    // Equality check, also excluding `Image` and `Color`
    static func == (lhs: Doctor, rhs: Doctor) -> Bool {
        return lhs.id == rhs.id &&
        lhs.firstName == rhs.firstName &&
        lhs.lastName == rhs.lastName &&
        lhs.description == rhs.description &&
        lhs.specialization == rhs.specialization
    }
}
