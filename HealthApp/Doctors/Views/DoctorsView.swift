//
//  DoctorsView.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-10-27.
//

import SwiftUI

struct DoctorsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var path = NavigationPath()
    private var doctors: [Doctor] = .doctorsSample
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section(header: Text("Recent Appointments")) {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(doctors.shuffled()) { doctor in
                                RecentAppointmentView(doctor: doctor)
                                    .onTapGesture {
                                        path.append(doctor)
                                    }
                            }
                        }
                    }
                    
                }.listRowBackground(Color.clear)
                
                Section(header: Text("My Doctors")) {
                    ForEach(doctors) { doctor in
                        SubtitleRowView(title: doctor.fullName, subtitle: doctor.specialization, image: doctor.profilePicture, backgroundColor: doctor.backgroundColor(for: colorScheme), action: {
                            path.append(doctor)
                        }).withDisclosureIndicator()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        path.append("HealthUser")
                    } label: {
                        Image(systemName: "qrcode.viewfinder")
                    }
                }
            }
            .navigationDestination(for: Doctor.self) { doctor in
                DoctorProfileView(doctor: doctor)
            }
            .navigationDestination(for: String.self) { code in
                QRView()
            }
            .navigationTitle("My Doctors")
        }
    }
}

#Preview {
    DoctorsView()
}
