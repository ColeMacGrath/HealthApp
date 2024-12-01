//
//  Modifiers.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-11-02.
//

import Foundation
import SwiftUI

struct CapsuleButtonModifier: ViewModifier {
    var backgroundColor: Color
    var fontColor: Color
    var cornerRadius: CGFloat = 18.0
    var image: Image?
    var imageForegroundColor: Color
    
    func body(content: Content) -> some View {
        HStack {
            if let image {
                image
                    .foregroundColor(imageForegroundColor)
            }
            content
                .foregroundColor(fontColor)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            Capsule(style: .continuous)
                .fill(backgroundColor)
        )
        
    }
}


struct CircularImageModifier: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        Circle()
            .fill(color)
            .overlay {
                content
                    .aspectRatio(contentMode: .fit)
                    .padding(.top, 5)
            }
            .clipShape(Circle())
    }
}

struct DisclosureIndicatorModifier: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            content
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
    }
}
