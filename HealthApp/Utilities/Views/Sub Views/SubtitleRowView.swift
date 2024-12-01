//
//  GeneralSubViews.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-11-02.
//

import Foundation
import SwiftUI

struct SubtitleRowView: View {
    var title: String
    var caption: String?
    var subtitle: String?
    var image: Image?
    var imageURL: URL?
    var backgroundColor: Color = .clear
    var action: (() -> Void)?
    var circularCustomization: Bool = true
    var titleFont: Font = .title3
    
    var body: some View {
        Button(action: {
            action?()
        }) {
            HStack {
                if let imageURL {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .circularImageStyle(color: backgroundColor)
                        default:
                            Color.gray
                                .clipShape(Circle())
                        }
                    }.frame(height: 60.0)
                } else if let image {
                    if circularCustomization {
                        image
                            .circularImageStyle(color: backgroundColor)
                            .frame(height: 60.0)
                    } else {
                        image
                    }
                }
                
                VStack(alignment: .leading) {
                    HStack(alignment: .bottom) {
                        Text(title)
                            .bold()
                            .font(titleFont)
                            .foregroundColor(.primary)
                        if let caption {
                            Text(caption)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    if let subtitle {
                        Text(subtitle)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}


#Preview {
    List {
        SubtitleRowView(title: "Title", caption: "Caption", subtitle: "Subtitle").withDisclosureIndicator()
    }
    
}
