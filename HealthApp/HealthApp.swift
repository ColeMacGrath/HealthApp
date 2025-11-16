//
//  HealthApp.swift
//  HealthApp
//
//  Created by Moises Cordova on 11/15/2025.
//

import SwiftUI

@main
struct HealthApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(TabBarViewModel())
        }
    }
}
