//
//  ContentView.swift
//  HealthApp
//
//  Created by Moises Cordova on 11/15/2025.
//

import SwiftUI

struct ContentView: View {
    @Environment(TabBarViewModel.self) private var viewModel
    @State private var showAddMenu = false
    
    var body: some View {
        if true {
            TabView {
                Tab("Home", systemImage: "house.fill") {
                    NavigationStack {
                        DashboardView()
                            .environment(viewModel)
                            .environment(DashboardViewModel())
                    }
                }
                
                Tab("Tools", systemImage: "apple.intelligence") {
                    NavigationStack {
                        
                    }
                }
                
                Tab("Add", systemImage: "plus", role: .search) {
                    AddFoodView()
                        .environment(AddFoodViewModel())
                }
                
            }
        } else {
            SignInView()
        }
        
        
    }
}

#Preview {
    ContentView()
        .environment(TabBarViewModel())
}
