//
//  HealthKitPermissionView.swift
//  HealthApp
//
//  Created by Moises Cordova on 11/15/2025.
//

import SwiftUI

struct HealthKitPermissionView: View {
    let status: HealthKitAuthorizationStatus
    let onAuthorize: () async -> Void
    let onOpenSettings: () -> Void
    @State private var isRequesting = false
    
    var body: some View {
        VStack(spacing: 32) {
            
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.red.gradient)
                    .frame(width: 120, height: 120)
                
                Image(systemName: "heart.text.square.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.white)
            }
            
            Text("HealthKit Access Required")
                .font(.title.bold())
            
            Text(descriptionText)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 16) {
                PermissionRow(icon: "figure.walk", title: "Activity & Steps", color: .green)
                PermissionRow(icon: "heart.fill", title: "Heart Rate", color: .red)
                PermissionRow(icon: "bed.double.fill", title: "Sleep Analysis", color: .indigo)
                PermissionRow(icon: "fork.knife", title: "Nutrition Data", color: .orange)
                PermissionRow(icon: "scalemass.fill", title: "Body Measurements", color: .purple)
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            Spacer()
            
            if case .denied = status {
                Button(action: onOpenSettings) {
                    HStack {
                        Image(systemName: "gear")
                        Text("Open Settings")
                            .padding()
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            } else {
                Button(action: {
                    Task {
                        isRequesting = true
                        await onAuthorize()
                        isRequesting = false
                    }
                }) {
                    HStack {
                        if isRequesting {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .tint(.white)
                        } else {
                            Image(systemName: "checkmark.shield.fill")
                            Text("Grant Access")
                        }
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(isRequesting)
            }
            
            Text("This app requires full HealthKit access to function properly")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
        }
        .padding(.horizontal)
        .interactiveDismissDisabled()
    }
    
    private var descriptionText: String {
        switch status {
        case .authorized:
            return "All permissions granted! Loading your health data..."
        case .notDetermined:
            return "We need access to your health data to provide personalized wellness insights and track your goals."
        case .denied:
            return "Some permissions were denied. Please enable all health data access in Settings to use this app."
        case .unavailable:
            return "HealthKit is not available on this device. This app requires an iPhone or iPad with health data support."
        }
    }
}

#Preview("Not Determined") {
    HealthKitPermissionView(
        status: .notDetermined(types: []),
        onAuthorize: {},
        onOpenSettings: {}
    )
}

#Preview("Denied") {
    HealthKitPermissionView(
        status: .denied(types: []),
        onAuthorize: {},
        onOpenSettings: {}
    )
}
