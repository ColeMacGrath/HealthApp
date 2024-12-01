//
//  VisualEffectBlur.swift
//  HealthAppUI
//
//  Created by Moisés Córdova on 2024-11-03.
//

import SwiftUI

struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = UIBlurEffect(style: blurStyle)
    }
}

#Preview {
    VisualEffectBlur(blurStyle: .systemUltraThinMaterialLight)
}
