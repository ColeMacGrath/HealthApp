//
//  DoctorProfileView.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-10-21.
//

import SwiftUI
import MapKit

struct DoctorProfileView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let doctor: Doctor
    
    var body: some View {
        ZStack {
            Color(doctor.backgroundColor(for: colorScheme))
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(doctor.specialization)
                            .foregroundStyle(.secondary)
                        Text(doctor.fullName)
                            .font(.title)
                        Text(doctor.description)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                        
                    }.padding(.horizontal)
                    Spacer()
                    doctor.profilePicture
                        .frame(width: 150, height: 300.0)
                        .padding(.leading)
                        .padding(.bottom, -10)
                }
                
                List {
                    SubtitleRowView(title: "Book Appointment", image: Image(systemName: "calendar.badge.plus"), circularCustomization: false, titleFont: .defaultFont).withDisclosureIndicator()
                    SubtitleRowView(title: "Add Doctor", image: Image(systemName: "person.fill.badge.plus"), circularCustomization: false, titleFont: .defaultFont).withDisclosureIndicator()
                    
                    SubtitleRowView(title: "About \(doctor.fullName)", image: Image(systemName: "person.crop.badge.magnifyingglass"), circularCustomization: false, titleFont: .defaultFont).withDisclosureIndicator()
                    
                    Section("St. Patrick st. 345") {
                        Map(coordinateRegion: $region)
                            .frame(height: 200)
                            .cornerRadius(16)
                            .onTapGesture {
                                //Open maps
                            }
                    }.listRowBackground(Color.clear)
                    
                    Section {
                        SubtitleRowView(title: "Delete \(doctor.fullName)", image: Image(systemName: "person.crop.badge.magnifyingglass"), circularCustomization: false, titleFont: .defaultFont)
                    }
                }
                .scrollBounceBehavior(.basedOnSize, axes: .vertical)
                .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
                .ignoresSafeArea()
                .shadow(color: .secondary, radius: 40.0, y: 15.0)
            }
        }
    }
}


#Preview {
    DoctorProfileView(doctor: Doctor(
        firstName: "Maria",
        lastName: "Lopez",
        description: "Dr. Maria Lopez is an empathetic Neurology Specialist, guiding patients through complex neurological disorders with care and the latest treatment advancements.",
        specialization: "Neurology Specialist",
        profilePicture: Image("doctor0"),
        lightBackgroundColor: Color(red: 0.929, green: 0.808, blue: 0.855), // Soft pinkish tone
        darkBackgroundColor: Color(red: 0.353, green: 0.106, blue: 0.196) // Deep wine red
    ))
}
