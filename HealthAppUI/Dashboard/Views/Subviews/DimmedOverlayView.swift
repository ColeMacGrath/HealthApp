//
//  DimmedOverlayView.swift
//  HealthAppUI
//
//  Created by Moisés Córdova on 2024-11-03.
//

import SwiftUI

struct DimmedOverlayView: View {
    var showAsCapsule: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                let rectangle = RoundedRectangle(cornerRadius: 20)
                    .frame(width: 250, height: 350)
                    .foregroundColor(.clear)
                    .background(VisualEffectBlur(blurStyle: .light))
                    .cornerRadius(20)
                    .blendMode(.destinationOut)
                if self.showAsCapsule {
                    rectangle
                        .clipShape(Capsule())
                } else {
                    rectangle
                        .frame(width: 250, height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
        }
    }
}

#Preview {
    DimmedOverlayView(showAsCapsule: true)
}
