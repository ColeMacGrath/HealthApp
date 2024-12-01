//
//  SearchType.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-11-03.
//

import Foundation

enum SearchType: String, CaseIterable, Identifiable {
    case week
    case month
    case year
    var id: String { rawValue }
}
