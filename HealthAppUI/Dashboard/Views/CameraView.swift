//
//  CameraView.swift
//  HealthAppUI
//
//  Created by Moisés Córdova on 2024-11-03.
//

import SwiftUI
import AVFoundation
import Vision

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
            //captureSession.startRunning()
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
        //private let feedbackGenerator = UINotificationFeedbackGenerator()
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
                //self.parent.handleQRCode(stringValue)
                //self.feedbackGenerator.notificationOccurred(.success)
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
                    //self.parent.handleFaceDetected(faceImage)
                    //self.feedbackGenerator.notificationOccurred(.success)
                }
            }
            do {
                try imageRequestHandler.perform([request])
            } catch {
                //self.parent.handleFaceDetected(nil)
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

#Preview {
    CameraView(scanType: .nevus)
}
