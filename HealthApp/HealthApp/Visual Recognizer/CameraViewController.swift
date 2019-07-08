import UIKit
import AVFoundation
import CoreML
import Vision

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet var cameraView: UIView!
    @IBOutlet var tempImageView: UIImageView!
    
    @IBOutlet var captureButton: UIButton!
    @IBOutlet var retakeButton: UIButton!
    
    //Variables de la cámara
    var captureSession: AVCaptureSession?
    var photoOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCamera()
        retake()
    }
    
    func initCamera(){
        self.captureSession = AVCaptureSession()
        self.captureSession?.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        
        if let backCamera = AVCaptureDevice.default(for: AVMediaType.video) {
            do {
                let input = try AVCaptureDeviceInput(device: backCamera)
                self.captureSession?.addInput(input)
                
                self.photoOutput = AVCapturePhotoOutput()
                if (self.captureSession?.canAddOutput(self.photoOutput!) != nil) {
                    self.captureSession?.addOutput(self.photoOutput!)
                    
                    self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
                    self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
                    self.previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                    self.cameraView.layer.addSublayer(self.previewLayer!)
                    self.captureSession?.startRunning()
                }
                
            } catch {
                /*let appearance = SCLAlertView.SCLAppearance( showCloseButton: false )
                let alert = SCLAlertView(appearance: appearance)
                alert.addButton("OK", action: {})
                alert.showError("Error", subTitle: NSLocalizedString("QRAnalyzer.error", comment: ""))*/
                print("ERROR: \(error)")
            }
            
            self.previewLayer?.frame = self.view.bounds
            
        } else {
            /*let appearance = SCLAlertView.SCLAppearance( showCloseButton: false )
            let alert = SCLAlertView(appearance: appearance)*/
            //alert.addButton("OK", action: {})
            //alert.showError("Error", subTitle: NSLocalizedString("QRAnalyzer.error", comment: ""))
        }
    
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("ERROR: \(error)")
            return
        }
        
        let photoData = photo.fileDataRepresentation()
        let dataProvider = CGDataProvider(data: photoData! as CFData)
        
        let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!,
                                 decode: nil,
                                 shouldInterpolate: true,
                                 intent: .defaultIntent)
        
        classify(cgImageRef!) { data in
            self.push(data: data)
        }
        
        let image = UIImage(data: photoData!)
        self.tempImageView.image = image
        self.tempImageView.isHidden = false
    }
    
    func classify(_ image: CGImage,
                  completion: @escaping ([VNClassificationObservation]) -> Void){
        
        DispatchQueue.global(qos: .background).async {
            guard let coremodel = try? VNCoreMLModel(for: Nevus().model) else {return}
            
            let request = VNCoreMLRequest(model: coremodel, completionHandler:
            { (request, error) in
                
                guard var results = request.results as? [VNClassificationObservation] else { fatalError("Fail processing the data") }
                
                results = results.filter({$0.confidence > 0.01})
                
                DispatchQueue.main.async {
                    completion(results)
                }
            })
            
            let handler = VNImageRequestHandler(cgImage: image)
            
            do{
                try handler.perform([request])
            } catch {
                print("Error: \(error)")
            }
            
            
        }
    }
    
    func dismissResults(){
        getTableController { (tablecontroller, drawer) in
            drawer.setDrawerPosition(position: .closed, animated: true)
            tablecontroller.classifications = []
        }
    }
    
    func push(data: [VNClassificationObservation]){
        getTableController { (tablecontroller, drawer) in
            tablecontroller.classifications = data
            self.dismiss(animated: true, completion: nil)
            drawer.setDrawerPosition(position: .partiallyRevealed, animated: true)
        }
    }
    
    func getTableController(run:
        (_ tableController: ResultsTableViewController,
         _ drawer: PulleyViewController)->Void){
        
        if let drawer = self.parent as? PulleyViewController {
            if let tablecontroller = drawer.drawerContentViewController as? ResultsTableViewController {
                run(tablecontroller, drawer)
                tablecontroller.tableView.reloadData()
            }
        }
        
    }
    
    @IBAction func takePhoto() {
        self.photoOutput?.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        self.captureButton.isHidden = true
        self.retakeButton.isHidden = false
        
        let alert = UIAlertController(title: NSLocalizedString("camera.processing", comment: ""), message: NSLocalizedString("camera.processing.message", comment: ""), preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.startAnimating()
        
        alert.view.addSubview(activityIndicator)
        present(alert, animated: true)
        
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func retake() {
        self.tempImageView.isHidden = true
        self.captureButton.isHidden = false
        self.retakeButton.isHidden  = true
        dismissResults()
    }
}
