//
//  HealthAppUIApp.swift
//  HealthAppUI
//
//  Created by Moisés Córdova on 2024-10-20.
//

import SwiftUI
import SwiftData

@main
struct HealthAppUIApp: App {
    @State private var loginModel = LoginModel()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            InitialView()
        }
        .modelContainer(sharedModelContainer)
        .environment(loginModel)
    }
}
