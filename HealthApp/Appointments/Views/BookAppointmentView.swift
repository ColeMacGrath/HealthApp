//
//  AppointmentView.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-10-30.
//

import SwiftUI

struct BookAppointmentView: View {
    @State private var selectedDate = Date()
    @State private var profileText = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                VStack {
                    List {
                        Section("Choose a date") {
                            DatePicker(
                                "Select Date",
                                selection: $selectedDate,
                                displayedComponents: [.date]
                            )
                            .datePickerStyle(.graphical)
                        }
                        
                        Section("Select Time") {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                                Button("10:00 AM") {
                                }.CapsuleButtonStyle(backgroundColor: .secondary)
                                Button("10:00 AM") {
                                    
                                }.CapsuleButtonStyle(backgroundColor: .secondary)
                                Button("10:00 AM") {
                                    
                                }.CapsuleButtonStyle(backgroundColor: .accent)
                                Button("10:00 AM") {
                                    
                                }.CapsuleButtonStyle(backgroundColor: .secondary)
                                Button("10:00 AM") {
                                    
                                }.CapsuleButtonStyle(backgroundColor: .secondary)
                                Button("10:00 AM") {
                                    
                                }.CapsuleButtonStyle(backgroundColor: .secondary)
                            }
                        }.listRowBackground(Color.clear)
                        
                        Section("Notes") {
                            TextEditor(text: $profileText)
                        }
                    }
                    
                    Button("Book Appointment") {
                    }.CapsuleButtonStyle()
                        .padding()
                }
                .navigationTitle("Book an appointment")
            }
        }
    }
}

#Preview {
    BookAppointmentView()
}
