//
//  FullScreenMessageView.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-10-31.
//

import SwiftUI

struct FullScreenMessageView: View {
    var image: Image? = nil
    var title: String
    var description: String? = nil
    var additionalInfo: String? = nil
    var buttonText: String? = nil
    var buttonAction: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .center) {
            if let image {
                image
                    .foregroundStyle(.accent)
                    .font(.system(size: 80))
                    .padding(.top)
            }
            
            Text(title)
                .bold()
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            
            if let description {
                Text(description)
                    .padding(.vertical)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            if let additionalInfo {
                Text(additionalInfo)
                    .foregroundStyle(.secondary)
                    .font(.callout)
                    .multilineTextAlignment(.center)
            }
            
            if let buttonText,
                let buttonAction {
                Button(buttonText, action: buttonAction)
                    .CapsuleButtonStyle()
            }
        }
        .padding()
    }
}

#Preview {
    FullScreenMessageView(image: Image(systemName: "heart.fill"), title: "Title", description: "Long-short description", additionalInfo: "Instrucctions about what to do next", buttonText: "Text button") {
        print("Action of button")
    }
}
