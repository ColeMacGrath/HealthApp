//
//  SelectableItem.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-11-03.
//

import SwiftUI

enum SelectableItem: CaseIterable, Identifiable {
    case home
    case doctors
    case appointments
    case intelligence
    
    var label: Label<Text, Image> {
        switch self {
        case .home: Label("Dashboard", systemImage: "heart")
        case .doctors: Label("Doctors", systemImage: "person.3")
        case .appointments: Label("Appointments", systemImage: "calendar.badge.clock")
        case .intelligence: Label("AI", systemImage: "apple.intelligence")
        }
    }
    
    @MainActor @ViewBuilder
    func destination(dashboardViewModel: DashboardModel) -> some View {
        switch self {
        case .home:
            DashboardView(viewModel: dashboardViewModel)
        case .doctors:
            DoctorsView()
        case .appointments:
            AppointmentsView()
        default:
            EmptyView()
            
        }
    }
    
    var id: SelectableItem { self }
}

