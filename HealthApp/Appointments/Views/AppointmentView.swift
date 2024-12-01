//
//  AppointmentView.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-10-30.
//

import SwiftUI
import MapKit

struct AppointmentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var showCancelledAppointmentView = false
    let doctor: Doctor
    var body: some View {
        
        ScrollView {
           // doctor.profilePicture
           //     .circularImageStyle(color: doctor.backgroundColor(for: colorScheme))
           //     .frame(height: 120.0)
            
            Text(doctor.fullName)
                .bold()
                .font(.title2)
            
            Text("Here's your upcoming appointment")
                .foregroundStyle(.secondary)
                .padding(.top)
            
            ZStack {
                Capsule(style: .continuous)
                    .foregroundStyle(Color.red.opacity(0.2))
                
                
                Text("December 16, 2025 at 04:00 PM")
                    .font(.callout)
                    .foregroundStyle(Color.red.opacity(1.0))
                    .padding()
            }.padding(.horizontal)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                
                Button("Call") {
                    
                }.CapsuleButtonStyle(backgroundColor: Color(.tertiarySystemGroupedBackground), fontColor: Color(.label), image: Image(systemName: "phone"), imageForegroundColor: .accent)
                
                Button("Message") {
                    
                }.CapsuleButtonStyle(backgroundColor: Color(.tertiarySystemGroupedBackground), fontColor: Color(.label), image: Image(systemName: "message"), imageForegroundColor: .accent)
                
                Button("Add to calendar") {
                    
                }.CapsuleButtonStyle(backgroundColor: Color(.tertiarySystemGroupedBackground), fontColor: Color(.label), image: Image(systemName: "calendar.badge.plus"), imageForegroundColor: .accent)
                
                Button("Map") {
                    
                }.CapsuleButtonStyle(backgroundColor: Color(.tertiarySystemGroupedBackground), fontColor: Color(.label), image: Image(systemName: "map"), imageForegroundColor: .accent)
                
                Button("Write a mail") {
                    
                }.CapsuleButtonStyle(backgroundColor: Color(.tertiarySystemGroupedBackground), fontColor: Color(.label), image: Image(systemName: "envelope"), imageForegroundColor: .accent)
                
                Button("See notes") {
                    
                }.CapsuleButtonStyle(backgroundColor: Color(.tertiarySystemGroupedBackground), fontColor: Color(.label), image: Image(systemName: "text.bubble"), imageForegroundColor: .accent)
            }.padding()
            
            VStack(alignment: .leading) {
                Map(coordinateRegion: $region)
                    .frame(height: 200)
                    .cornerRadius(16)
                    .padding()
                Text("Colorado St. 145")
                    .foregroundStyle(.secondary)
                    .padding([.leading, .bottom])
            }
            
            Button("Cancel Appointment") {
                showCancelledAppointmentView = true
            }
            .CapsuleButtonStyle()
            .padding()
            
        }
        .scrollBounceBehavior(.basedOnSize, axes: .vertical)
        .sheet(isPresented: $showCancelledAppointmentView) {
            FullScreenMessageView(
                image: Image(systemName: "calendar.badge.minus"),
                title: "Appointment Cancelled",
                description: "Your appointment is now cancelled, there's not additional actions",
                buttonText: "Done") {
                    showCancelledAppointmentView = false
                }
        }
    }
}

#Preview {
    /*AppointmentView(doctor: Doctor(
        firstName: "Maria",
        lastName: "Lopez",
        description: "Dr. Maria Lopez is an empathetic Neurology Specialist, guiding patients through complex neurological disorders with care and the latest treatment advancements.",
        specialization: "Neurology Specialist",
        profilePicture: Image("doctor0"),
        lightBackgroundColor: Color(red: 0.929, green: 0.808, blue: 0.855), // Soft pinkish tone
        darkBackgroundColor: Color(red: 0.353, green: 0.106, blue: 0.196) // Deep wine red
    ))*/
}
