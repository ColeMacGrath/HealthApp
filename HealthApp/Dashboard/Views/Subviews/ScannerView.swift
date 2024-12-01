//
//  ScannerView.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-11-03.
//

import SwiftUI
import Vision

struct ScannerView: View {
    @Environment(\.presentationMode) var presentationMode
    var scanType: ScanType
    var description: String?
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    var onImageCapture: ((UIImage?) -> Void)?
    
    var body: some View {
        ZStack {
            if self.scanType == .qr {
                CameraView(scanType: self.scanType, onQRCodeDetected: handleQRCode)
            } else {
                CameraView(scanType: self.scanType, onImageCapture: { capturedImage in
                    self.presentationMode.wrappedValue.dismiss()
                    self.onImageCapture?(capturedImage)
                })
            }
            
            DimmedOverlayView(showAsCapsule: self.scanType == .face)
                .foregroundStyle(.white)
            if self.scanType == .face {
                Capsule()
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [10]))
                    .frame(width: 250, height: 350)
                    .foregroundColor(.white)
            } else {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [10]))
                    .frame(width: 250, height: 250)
                    .foregroundColor(.white)
            }
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.red)
                            .padding()
                    }
                }
                Spacer()
                VStack {
                    if let description {
                        ZStack {
                            Text(description)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black.opacity(0.5))
                                .cornerRadius(10)
                        }
                    }
                    if self.scanType == .nevus {
                        Button(action: {
                            
                        }, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10.0)
                                Text("Capture")
                                    .bold()
                                    .foregroundStyle(.white)
                            }
                            .frame(height: 35.0)
                            .padding()
                        })
                    }
                }
            }
        }.alert(isPresented: $showAlert) {
            Alert(title: Text(self.alertTitle), message: Text(self.alertMessage), dismissButton: .default(Text("OK"), action: {
                guard self.alertMessage.isEmpty else { return }
                self.presentationMode.wrappedValue.dismiss()
            }))
        }
    }
    
    private func handleQRCode(_ code: String) {
        //guard let patientId = SessionManager.shared.getPatientId() else { return }
        if self.isValidHealthAppURL(code) {
            /*Task {
                let response = await RequestManager.shared.request(endPoint: .doctors, method: .patch, body: [
                    "userId": patientId,
                    "doctorId": code
                ])
                
                guard response.httpStatusCode == .success else {
                    self.alertTitle = "Couldn't add Doctor"
                    self.alertMessage = "Couldn't add this doctor, check QR is valid and doctor is active"
                    self.showAlert = true
                    return
                }
                
                self.alertTitle = "Doctor Added"
                self.alertMessage = ""
                self.showAlert = true
            }*/
        } else {
            self.alertTitle = "Couldn't add Doctor"
            self.alertMessage = "Invalid QR Code, check code is a HealthApp Code"
            self.showAlert = true
        }
    }
    
    private func isValidHealthAppURL(_ urlString: String) -> Bool {
        let pattern = "^healthApp://[a-zA-Z0-9]+$"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return false }

        let range = NSRange(location: 0, length: urlString.utf16.count)
        return regex.firstMatch(in: urlString, options: [], range: range) != nil
    }
    
}

#Preview {
    ScannerView(scanType: .nevus)
}
