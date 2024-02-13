//
//  CaloriesSummaryViewController.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 03/01/24.
//

import UIKit

class CaloriesSummaryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createRecommendationButton: UIButton!
    private let imagePicker = UIImagePickerController()
    private var ingredientsImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .photoLibrary

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[.originalImage] as? UIImage else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        self.createRecommendationButton.isEnabled = true
        self.ingredientsImage = pickedImage
        self.tableView.reloadSections(IndexSet(arrayLiteral: 2), with: .automatic)
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func createRecommendationButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: Constants.Segues.showRecommendationViewController, sender: nil)
    }
}

extension CaloriesSummaryViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section < 2 else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.imageCell, for: indexPath) as! ImageTableViewCell
            if let ingredientsImage {
                cell.customImageView.image = ingredientsImage
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.basicCell, for: indexPath)
        var configuration = UIListContentConfiguration.cell()
        if indexPath.section == 0 {
            configuration.text = "Calories consumed"
            configuration.secondaryText = "1345"
        } else {
            configuration.text = "Calories Left"
            configuration.secondaryText = "1450"
        }
        cell.contentConfiguration = configuration
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 2 else { return }
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 2 ? 300.0 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 2 else { return nil }
        let text = self.ingredientsImage != nil ? "Image selected" : "Select an image"
        return text
    }
}
