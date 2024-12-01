//
//  QRView.swift
//  HealthAppUI
//
//  Created by Moisés Córdova on 2024-11-03.
//

import SwiftUI

import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRView: View {
    @State private var isPresentingCamera = false
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 18.0)
                    .frame(width: 350.0, height: 350.0)
                    .foregroundStyle(Color(uiColor: .secondarySystemBackground))
                    .shadow(color: .gray, radius: 20, x: 0, y: 20)
                Image(uiImage: generateQRCode(from: "Value"))
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .overlay(
                        Image(.profile)
                            .circularImageStyle(color: .cyan)
                            .frame(width: 60, height: 60)
                    )
            }
            .padding(.bottom)
            Text("Allison Doe")
                .bold()
                .font(.title)
            
            Spacer()
            
            if let url = URL(string: "healthApp://userID12") {
                ShareLink(item: url) {
                    Button("Share") {
                        self.isPresentingCamera = true
                    }.CapsuleButtonStyle(image:  Image(systemName: "square.and.arrow.up"))
                        .padding(.horizontal)
                }
            }
            
            Button("Scan QR") {
                self.isPresentingCamera = true
            }.CapsuleButtonStyle(backgroundColor: .blue, image:  Image(systemName: "qrcode.viewfinder"))
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemGroupedBackground))
        .padding(.bottom)
        .sheet(isPresented: $isPresentingCamera) {
            ScannerView(scanType: .qr)
        }
    }
}

func generateQRCode(from string: String) -> UIImage {
    let filter = CIFilter.qrCodeGenerator()
    let data = Data(string.utf8)
    filter.setValue(data, forKey: "inputMessage")
    
    let context = CIContext()
    let transform = CGAffineTransform(scaleX: 10, y: 10)
    
    guard let qrImage = filter.outputImage?.transformed(by: transform),
          let qrCodeCGImage = context.createCGImage(qrImage, from: qrImage.extent)else {
        return UIImage()
    }
    let imageSize = qrImage.extent.size
    UIGraphicsBeginImageContext(imageSize)
    
    let graphicsContext = UIGraphicsGetCurrentContext()
    graphicsContext?.draw(qrCodeCGImage, in: qrImage.extent)
    
    let modifiedQRCodeImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return modifiedQRCodeImage ?? UIImage()
}

#Preview {
    QRView()
}
