//
//  ImageSourceMenuView.swift
//  HealthApp
//
//  Created by Moises Cordova on 11/15/2025.
//

import SwiftUI

struct ImageSourceMenuView: View {
    @Binding var showMenu: Bool
    @Binding var showCamera: Bool
    @Binding var showPhotos: Bool
    
    var body: some View {
        VStack(spacing: 20.0) {
            menuItem( icon: "camera.fill", iconColor: .blue, title: "Camera", action: {
                    showMenu = false
                    showCamera = true
                }
            )
            
            menuItem( icon: "photo.on.rectangle", iconColor: .purple, title: "Photos", action: {
                    showMenu = false
                    showPhotos = true
                }
            )
        }
    }
    
    @ViewBuilder
    private func menuItem(icon: String, iconColor: Color, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.title)
                        .foregroundStyle(iconColor)
                }
                
                Text(title)
                    .font(.title3)
                    .foregroundStyle(.primary)
                
                Spacer()
            }
            .padding(.leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
