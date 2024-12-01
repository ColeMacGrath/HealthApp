//
//  ContentView.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-10-20.
//

import SwiftUI

struct InitialView: View {
    @State private var screen: SelectableItem? = .home
    @StateObject private var dashboardViewModel = DashboardModel()
    
    
    var body: some View {
        if true {
            LoginView()
        } else {
            TabView {
                ForEach(SelectableItem.allCases) { screen in
                    NavigationStack {
                        screen.destination(dashboardViewModel: dashboardViewModel)
                    }
                    .tabItem { screen.label }
                }
            }
        }
    }
}

#Preview {
    InitialView()
}
