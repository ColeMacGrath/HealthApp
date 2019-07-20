//
//  QRViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 7/19/19.
//  Copyright © 2019 Moisés Córdova. All rights reserved.
//

import UIKit
import FloatingPanel

class QRViewController: UIViewController {
    
    var fpc: FloatingPanelController!
    var patientUID: String!
    @IBOutlet var qrImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateQR()
        // Do any additional setup after loading the view.
    }

    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        fpc.hide(animated: true, completion: nil)
    }
    
    func generateQR() {
       let data = patientUID.data(using: .ascii, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            let ciImage = filter?.outputImage
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let transformImage = ciImage?.transformed(by: transform)
            let image = UIImage(ciImage: transformImage!)
            qrImageView.image = image
        
    }
}
