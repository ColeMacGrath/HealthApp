//
//  QRView.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 30/12/23.
//

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
                        Image("profile")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .background(Color.white)
                            .clipShape(Circle())
                        , alignment: .center
                    )
            }
            .padding(.bottom, 30.0)
            Text("John Doe")
                .bold()
                .font(.title)
            
            Spacer()
            
            if let url = URL(string: "healthApp://userID12") {
                ShareLink(item: url) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 18.0)
                            .frame(width: 350.0, height: 50.0)
                            .foregroundStyle(.red)
                        HStack {
                            Image(systemName: "square.and.arrow.up.fill")
                            Text("Share")
                                .bold()
                        }.foregroundStyle(.white)
                    }
                }
            }
            
            Button {
                self.isPresentingCamera = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 18.0)
                        .frame(width: 350.0, height: 50.0)
                        .foregroundStyle(.blue)
                    HStack {
                        Image(systemName: "qrcode.viewfinder")
                        Text("Scan")
                            .bold()
                    }.foregroundStyle(.white)
                }
                
            }
            
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


struct QRView_Previews: PreviewProvider {
    static var previews: some View {
        QRView()
    }
}
