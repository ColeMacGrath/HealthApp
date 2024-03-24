//
//  ScannerView.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 30/12/23.
//

import SwiftUI
import AVFoundation
import Vision

enum ScanType {
    case qr
    case nevus
    case face
}

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
        guard let patientId = SessionManager.shared.getPatientId() else { return }
        if self.isValidHealthAppURL(code) {
            Task {
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
            }
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

struct CameraView: UIViewControllerRepresentable {
    private let captureSession = AVCaptureSession()
    private let metadataOutput = AVCaptureMetadataOutput()
    private let videoOutput = AVCaptureVideoDataOutput()
    var scanType: ScanType
    var onImageCapture: ((UIImage?) -> Void)?
    var onQRCodeDetected: ((String) -> Void)?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, onImageCapture: onImageCapture)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        viewController.hidesBottomBarWhenPushed = true
        
        guard var videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return viewController }
        
        if self.scanType == .face,
           let frontCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            videoCaptureDevice = frontCaptureDevice
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                return viewController
            }
            
            if self.scanType == .face {
                guard captureSession.canAddOutput(videoOutput) else { return viewController }
                captureSession.addOutput(videoOutput)
                videoOutput.setSampleBufferDelegate(context.coordinator, queue: DispatchQueue.main)
            } else {
                guard captureSession.canAddOutput(metadataOutput) else { return viewController }
                captureSession.addOutput(metadataOutput)
                metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.qr]
                
            }
        } catch {
            return viewController
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewController.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.startRunning()
        }
        
        return viewController
    }
    
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    func handleQRCode(_ code: String) {
        self.stopScanning()
        
        DispatchQueue.main.async {
            self.onQRCodeDetected?(code)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            self.resumeScanning()
        })
    }
    
    func handleFaceDetected(_ face: UIImage?) {
        self.stopScanning()
        self.onImageCapture?(face)
    }
    
    func stopScanning() {
        if self.scanType == .face {
            captureSession.removeOutput(videoOutput)
        } else {
            captureSession.removeOutput(metadataOutput)
        }
    }
    
    func resumeScanning() {
        if self.scanType == .face,
           !captureSession.outputs.contains(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            if !captureSession.outputs.contains(metadataOutput) {
                captureSession.addOutput(metadataOutput)
            }
        }
        
    }
    
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
        private let feedbackGenerator = UINotificationFeedbackGenerator()
        var parent: CameraView
        var onImageCapture: ((UIImage?) -> Void)?
        
        init(_ parent: CameraView, onImageCapture: ((UIImage?) -> Void)?) {
            self.parent = parent
            self.onImageCapture = onImageCapture
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            guard let metadataObject = metadataObjects.first,
                  let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                  let stringValue = readableObject.stringValue else { return }
            DispatchQueue.main.async {
                self.parent.handleQRCode(stringValue)
                self.feedbackGenerator.notificationOccurred(.success)
            }
        }
        
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up)
            
            let request = VNDetectFaceRectanglesRequest { request, error in
                guard error == nil,
                      let firstResult = (request.results as? [VNFaceObservation])?.first,
                      let faceImage = self.extractFaceImage(from: firstResult, in: pixelBuffer) else { return }
                DispatchQueue.main.async {
                    self.parent.handleFaceDetected(faceImage)
                    self.feedbackGenerator.notificationOccurred(.success)
                }
            }
            do {
                try imageRequestHandler.perform([request])
            } catch {
                self.parent.handleFaceDetected(nil)
            }
        }
        
        private func extractFaceImage(from faceObservation: VNFaceObservation, in pixelBuffer: CVPixelBuffer) -> UIImage? {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let imageSize = ciImage.extent.size
            let faceRect = VNImageRectForNormalizedRect(faceObservation.boundingBox, Int(imageSize.width), Int(imageSize.height))
            let croppedCIImage = ciImage.cropped(to: faceRect)
            let context = CIContext()
            guard let cgImage = context.createCGImage(croppedCIImage, from: croppedCIImage.extent) else { return nil }
            return UIImage(cgImage: cgImage)
        }
        
    }
}

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

struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = UIBlurEffect(style: blurStyle)
    }
}

struct QRScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView(scanType: .nevus)
    }
}
