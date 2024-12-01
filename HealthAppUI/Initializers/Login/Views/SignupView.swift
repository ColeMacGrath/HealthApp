//
//  SignupView.swift
//  HealthAppUI
//
//  Created by Moisés Córdova on 2024-11-03.
//

import SwiftUI

struct SignupView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Start by sign in and stay connect with your health and your doctors in a few touches.")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom)
                
                
                HStack {
                    Button("I'm a patient") {
                        
                    }.CapsuleButtonStyle(image: Image(systemName: "person"), imageForegroundColor: .white)
                    
                    Button("I'm a doctor") {
                        
                    }.CapsuleButtonStyle(backgroundColor: Color(.tertiarySystemGroupedBackground), fontColor: Color(.label), image: Image(systemName: "heart.text.clipboard"), imageForegroundColor: .accent)
                }
                
                
                OutlinedTextField(text: .constant(""), placeholder: "Enter your mail", image: Image(systemName: "envelope.fill"))
                    .padding(.vertical)
                OutlinedTextField(text: .constant(""), isSecure: true, placeholder: "Enter your password", image: Image(systemName: "lock.fill"))
                OutlinedTextField(text: .constant(""), isSecure: true, placeholder: "Repeat password", image: Image(systemName: "lock.fill")).padding(.vertical)
                
                Button("Sign up") {
                    
                }
                .CapsuleButtonStyle()
                
                HStack {
                    Rectangle()
                        .frame(height: 1.0)
                    Text("Or")
                    Rectangle()
                        .frame(height: 1.0)
                }
                .padding()
                .foregroundStyle(.secondary)
                
                
                
                Button("Sign up With Apple") {
                    
                }
                .CapsuleButtonStyle(backgroundColor: Color(.label), fontColor: Color(.systemBackground), image: Image(systemName: "apple.logo"), imageForegroundColor: Color(.systemBackground))
                Spacer()
            }
            .padding()
            .navigationTitle("Sign Up")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        
                    }
                }
            }
        }
    }
}

#Preview {
    SignupView()
}
