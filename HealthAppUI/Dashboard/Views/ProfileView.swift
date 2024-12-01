//
//  ProfileView.swift
//  HealthAppUI
//
//  Created by Moisés Córdova on 2024-11-02.
//

import SwiftUI

struct ProfileView: View {
    @Environment(LoginModel.self) private var model
    @Environment(\.presentationMode) private var presentationMode
    private var fitzPatrickScale: FitzPatrickScale = .I
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                VStack {
                    List {
                        Section {
                            VStack {
                                Image(.profile)
                                    .circularImageStyle(color: .cyan)
                                    .frame(height: 120)
                                Text("Allison Doe")
                                    .bold()
                                    .font(.title2)
                            } .frame(maxWidth: .infinity)
                        }
                        
                        .listRowBackground(Color.clear)
                        
                        Section {
                            SubtitleRowView(title: "Biological Sex", subtitle: "Female")
                            SubtitleRowView(title: "Age", subtitle: "27")
                            SubtitleRowView(title: "Wheelchair Use", subtitle: "No")
                            HStack {
                                SubtitleRowView(title: "Fitzpatrick Skin Type", subtitle: fitzPatrickScale.rawValue)
                                Spacer()
                                RoundedRectangle(cornerRadius: 16.0)
                                    .fill(HealthKitManager().getColorFor(fitzPatricScale: fitzPatrickScale))
                                    .frame(width: 60.0, height: 60.0)
                            }
                        }
                        
                    }
                    .navigationTitle("Me")
                    .navigationBarTitleDisplayMode(.inline)
                    .scrollBounceBehavior(.basedOnSize, axes: .vertical)
                    
                    Button("Save") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .CapsuleButtonStyle()
                    .padding(.horizontal)
                    
                    Button("Logout") {
                        model.logOut()
                    }
                    
                }.toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }.buttonStyle(.automatic)
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
        .environment(LoginModel())
}
