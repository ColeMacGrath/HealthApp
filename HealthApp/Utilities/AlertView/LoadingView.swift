//
//  LoadingView.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-11-03.
//

import Foundation
import SwiftUI

struct LoadingView: View {
    var fullScreen: Bool = false
    var message: String? = nil
    var color: Color = .accentColor
    
    var body: some View {
        if fullScreen {
            ZStack {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    BeatingHeart(color: color)
                        .frame(width: 200, height: 200)
                    Text(message ?? .empty)
                }
                .foregroundStyle(color)
            }
            .transition(.opacity)
        } else {
            VStack(alignment: .center) {
                BeatingHeart(color: color)
                    .frame(width: 200, height: 200)
                Text(message ?? .empty)
                    .bold()
                    .font(.title2)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
            )
            
            .shadow(radius: 10)
            .transition(.scale)
            .foregroundStyle(color)
        }
    }
}

#Preview {
    LoadingView(message: "Logging in")
}

