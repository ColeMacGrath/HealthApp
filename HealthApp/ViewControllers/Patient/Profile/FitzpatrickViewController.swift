//
//  FitzpatrickViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-01-14.
//

import UIKit
import SwiftUI
import HealthKit
import CoreML
import Vision

class FitzpatrickViewController: UIViewController {
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    private var skinType: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let fitzpatrickSkinType = HealthKitManager.shared.retrieveSecureFitzpatrickSkinType() {
            self.skinType = fitzpatrickSkinType
            self.detailLabel.text = "Fitzpatrick Scale: \(fitzpatrickSkinType.toRomanNumeral() ?? .empty)"
            self.emojiLabel.text = self.getEmojiFor(fitzpatrickSkinType: fitzpatrickSkinType.toRomanNumeral() ?? .empty)
        } else {
            HealthKitManager.shared.getFitzpatrickSkinType { value, _ in
                guard let value else { return }
                self.detailLabel.text = "Fitzpatrick Scale: \(value)"
                self.emojiLabel.text = self.getEmojiFor(fitzpatrickSkinType: value)
            }
        }
    }
    
    @IBAction func scanFaceButtonPressed(_ sender: UIButton) {
        let scannerView = ScannerView(scanType: .face, description: "Center your face in the oval, face will be automatically detected", onImageCapture: { faceImage in
            guard let faceImage else { return }
            self.fitzpatrickPredictionFrom(image: faceImage) { scale in
                guard let scale,
                      let stringScale = scale.toRomanNumeral() else { return }
                self.skinType = scale
                self.detailLabel.text = "Fitzpatrick Scale: \(stringScale)"
                self.emojiLabel.text = self.getEmojiFor(fitzpatrickSkinType: stringScale)
            }
            
        })
        let hostingController = UIHostingController(rootView: scannerView)
        self.present(hostingController, animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if let skinType {
            if HealthKitManager.shared.saveFitzpatrick(skinType: skinType) { print("SAVED") }
        }
        self.dismiss(animated: true)
    }
    
    @IBAction func moreInformationButtonPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "ShowExplanationVC", sender: nil)
    }
    
    private func fitzpatrickPredictionFrom(image: UIImage, completion: @escaping (Int?) -> Void) {
        guard let model = try? VNCoreMLModel(for: FitzpatrickScale().model) else {
            completion(nil)
            return
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first,
                  let scaleValue = Int(topResult.identifier) else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                completion(scaleValue)
            }
        }
        
        guard let ciImage = CIImage(image: image) else {
            completion(nil)
            return
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage)
        do {
            try handler.perform([request])
        } catch {
            completion(nil)
        }
    }
    
    private func getEmojiFor(fitzpatrickSkinType: String) -> String {
        switch fitzpatrickSkinType {
        case "I":
            return "🧑🏻‍🦲"
        case "II":
            return "🧑🏼‍🦲"
        case "III":
            return "🧑🏽‍🦲"
        case "IV":
            return "🧑🏾‍🦲"
        case "V", "VI":
            return "🧑🏿‍🦲"
        default:
            return "🧑‍🦲"
        }
    }
}
