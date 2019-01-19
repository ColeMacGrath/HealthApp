import UIKit
import AVFoundation
import SCLAlertView

class QRAnalyzerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet var videoPreview: UIView!
    var doctorUID = String()
    
    enum error: Error {
        case noCameraAvailable
        case videoInputInitFail
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try scanQRCode()
        } catch {
            let appearance = SCLAlertView.SCLAppearance( showCloseButton: false )
            let alert = SCLAlertView(appearance: appearance)
            alert.addButton("OK", action: {})
            alert.showError("Error", subTitle: NSLocalizedString("QRAnalyzer.error", comment: ""))
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            let machineReadeableCode = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            if machineReadeableCode.type == AVMetadataObject.ObjectType.qr {
                doctorUID = machineReadeableCode.stringValue!
                DatabaseService.shared.doctorsRef.observeSingleEvent(of: .value) { (snapshot) in
                    if let doctors = snapshot.value as? Dictionary<String, AnyObject> {
                        for (key, value) in doctors {
                            if let dict = value as? Dictionary<String, AnyObject> {
                                if let profile = dict["profile"] as? Dictionary<String, AnyObject> {
                                    if let firstName = profile["firstName"] as? String, let lastName = profile["lastName"] as? String, let direction = profile["direction"] as? String, let email = profile["email"] as? String, let phone = profile["phone"] as? String, let specialty = profile["speciality"] as? String {
                                        let uid = key
                                        if uid == self.doctorUID {
                                            let doctor = Doctor(uid: uid, firstName: firstName, lastName: lastName, direction: direction, email: email, phone: phone, specialty: specialty, profilePicture: UIImage(named: "picture")!)
                                            DatabaseService.shared.addDoctor(doctor: doctor)
                                            self.dismiss(animated: true, completion: nil)
                                        } // The ID does not match
                                    } // Can not extract the data
                                }
                            } // Can not build the dictionary
                        }
                    } // There are no doctors
                }
                
            } // Unable to create the reading object
        }
    }
    
    func scanQRCode() throws {
        let avCaptureSession =  AVCaptureSession()
        guard let avCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("No camera available")
            throw error.noCameraAvailable
        }
        
        guard let avCaptureInput = try? AVCaptureDeviceInput(device: avCaptureDevice) else {
            print("Failed to  init camera")
            throw error.videoInputInitFail
        }
        
        let avCaptureMetadataOutput = AVCaptureMetadataOutput()
        avCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        avCaptureSession.addInput(avCaptureInput)
        avCaptureSession.addOutput(avCaptureMetadataOutput)
        
        avCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        let avCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession)
        avCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        avCaptureVideoPreviewLayer.frame = videoPreview.bounds
        self.videoPreview.layer.addSublayer(avCaptureVideoPreviewLayer)
        avCaptureSession.startRunning()
    }
    
    

}
