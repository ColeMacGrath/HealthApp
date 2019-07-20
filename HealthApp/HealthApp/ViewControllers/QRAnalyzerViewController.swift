import UIKit
import AVFoundation
import RealmSwift
//import SCLAlertView

class QRAnalyzerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet var videoPreview: UIView!
    var doctorUID = String()
    let realm = try? Realm()
    var patient: Patient!
    
    enum error: Error {
        case noCameraAvailable
        case videoInputInitFail
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try scanQRCode()
        } catch {
            /*let appearance = SCLAlertView.SCLAppearance( showCloseButton: false )
             let alert = SCLAlertView(appearance: appearance)
             alert.addButton("OK", action: {})
             alert.showError("Error", subTitle: NSLocalizedString("QRAnalyzer.error", comment: ""))*/
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            let machineReadeableCode = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            if machineReadeableCode.type == AVMetadataObject.ObjectType.qr {
                doctorUID = machineReadeableCode.stringValue!
                DatabaseService.shared.doctorsRef.child(doctorUID).observeSingleEvent(of: .value) {
                    (snapshot) in
                    if let doctorDict = snapshot.value as? Dictionary<String, AnyObject> {
                        if let firstName = doctorDict["firstName"] as? String,
                            let lastName = doctorDict["lastName"] as? String,
                            let address = doctorDict["address"] as? String,
                            let phone = doctorDict["phone"] as? String,
                            let email = doctorDict["email"] as? String,
                            let specialty = doctorDict["specialty"] as? String
                        {
                            DispatchQueue.main.async {
                                DatabaseService.shared.addDoctor(doctorUID: self.doctorUID, patientUID: self.patient!.uid)
                                if self.realm?.object(ofType: Doctor.self, forPrimaryKey: self.doctorUID) == nil {
                                    let localDoctor = Doctor(uid: self.doctorUID, firstName: firstName, lastName: lastName, direction: address, email: email, phone: phone, specialty: specialty, profilePicture: nil)
                                    do {
                                        try? self.realm?.write {
                                            self.patient.doctors.append(localDoctor)
                                        }
                                    }
                                }
                            }
                            self.dismiss(animated: true)
                        }
                    } // Can not build the dictionary, doctor doesn't exists
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
