//
//  PermissionRow.swift
//  HealthApp
//
//  Created by Moises Cordova on 11/15/2025.
//

import SwiftUI

struct PermissionRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
                .frame(width: 32)
            
            Text(title)
                .font(.body)
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.secondary)
        }
    }
}
