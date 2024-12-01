//
//  AppointmentsView.swift
//  HealthAppUI
//
//  Created by Moisés Córdova on 2024-10-30.
//

import SwiftUI

struct AppointmentsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedDate = Date()
    @State private var path = NavigationPath()
    var doctors: [Doctor] = .doctorsSample
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section("Friday") {
                    VStack(alignment: .leading) {
                        Text("March 27\n2024").bold()
                    }
                    .font(.largeTitle)
                    .foregroundStyle(.accent)
                    .overlay {
                        DatePicker(String.empty, selection: $selectedDate, displayedComponents: [.date]
                        )
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .blendMode(.destinationOver)
                    }
                }.listRowBackground(Color.clear)
                
                Section("Upcoming Appointments") {
                    ForEach(doctors) { doctor in
                        SubtitleRowView(title: doctor.fullName, subtitle: "December 16, 2024 at 04:00 PM", image: doctor.profilePicture, backgroundColor: doctor.backgroundColor(for: colorScheme))
                            .withDisclosureIndicator()
                            .onTapGesture {
                                path.append(doctor)
                            }
                        
                    }
                }
                
            }
            .navigationTitle("My Appointments")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Doctor.self) { doctor in
                AppointmentView(doctor: doctor)
            }
        }
    }
}

#Preview {
    AppointmentsView()
}
