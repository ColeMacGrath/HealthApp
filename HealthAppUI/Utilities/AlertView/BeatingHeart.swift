//
//  BeatingHeart.swift
//  HealthAppUI
//
//  Created by Moisés Córdova on 2024-11-03.
//

import Foundation
import SwiftUI

struct BeatingHeart: View {
    var color: Color
    @State private var isBeating = false
    
    var body: some View {
        Image(systemName: "heart.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(color)
            .scaleEffect(isBeating ? 1.2 : 1.0)
            .padding(30)
            .animation(
                .easeInOut(duration: 0.6)
                .repeatForever(autoreverses: true),
                value: isBeating
            )
            .onAppear {
                isBeating = true
            }
    }
}
