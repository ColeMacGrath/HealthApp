//
//  TabBarViewModel.swift
//  HealthApp
//
//  Created by Moises Cordova on 11/15/2025.
//

import SwiftUI

@Observable
final class TabBarViewModel {
    var showInputSheet = false
    var dishDescription = ""
    var selectedSuggestions: Set<String> = []
}
