//
//  LoadingAlertModifier.swift
//  HealthAppUI
//
//  Created by Moisés Córdova on 2024-11-03.
//

import Foundation
import SwiftUI

struct LoadingAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    var message: String?
    var color: Color = .accentColor
    var fullscreen: Bool = false
    
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isPresented)
            
            if isPresented {
                LoadingView(fullScreen: fullscreen, message: message, color: color)
                    .transition(.opacity)
                    .animation(.easeInOut, value: isPresented)
            }
        }
    }
}
