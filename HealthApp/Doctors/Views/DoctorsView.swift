//
//  DoctorsView.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-10-27.
//

import SwiftUI

struct DoctorsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(DoctorsModel.self) private var model
    @State private var path = NavigationPath()
    
    var body: some View {
        @Bindable var model = model
        NavigationStack(path: $path) {
            List {
                Section(header: Text("Recent Appointments")) {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(model.doctors) { doctor in
                                RecentAppointmentView(doctor: doctor)
                                    .onTapGesture {
                                        path.append(doctor)
                                    }
                            }
                        }
                    }
                    
                }.listRowBackground(Color.clear)
                
                Section(header: Text("My Doctors")) {
                    ForEach(model.doctors) { doctor in
                        SubtitleRowView(title: doctor.fullName, subtitle: doctor.specialization, imageURL: doctor.profilePicture, action: {
                            path.append(doctor)
                        }).withDisclosureIndicator()
                        
                        /*SubtitleRowView(title: doctor.fullName, subtitle: doctor.specialization, image: doctor.profilePicture, backgroundColor: doctor.backgroundColor(for: colorScheme), action: {
                            path.append(doctor)
                        }).withDisclosureIndicator()*/
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
        }.onAppear {
            Task {
                await model.fectchDoctors()
            }
            
        }
    }
}

#Preview {
    DoctorsView()
        .environment(DoctorsModel())
}
