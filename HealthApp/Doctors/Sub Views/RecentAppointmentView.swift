//
//  RecentAppointmentView.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-11-03.
//

import SwiftUI

struct RecentAppointmentView: View {
    @Environment(\.colorScheme) private var colorScheme
    var doctor: Doctor
    var body: some View {
        VStack {
            doctor.profilePicture
                .circularImageStyle(color: doctor.backgroundColor(for: colorScheme))
                .frame(height: 100.0)
            Text(doctor.fullName)
                .bold()
            
        }.padding(.trailing)
    }
}


#Preview {
    RecentAppointmentView(doctor: Doctor(
        firstName: "Maria",
        lastName: "Lopez",
        description: "Dr. Maria Lopez is an empathetic Neurology Specialist, guiding patients through complex neurological disorders with care and the latest treatment advancements.",
        specialization: "Neurology Specialist",
        profilePicture: Image("doctor0"),
        lightBackgroundColor: Color(red: 0.929, green: 0.808, blue: 0.855),
        darkBackgroundColor: Color(red: 0.353, green: 0.106, blue: 0.196)
    ))
}
