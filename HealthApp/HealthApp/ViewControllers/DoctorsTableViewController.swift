//
//  DoctorsTableViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 09/06/20.
//  Copyright © 2020 Moisés Córdova. All rights reserved.
//

import UIKit

class DoctorsTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    var number = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func addDoctorButtonPressed(_ sender: UIBarButtonItem) {
        guard let (controller, activityViewController) = storyboard?.createMenu(options: ["Escanear QR", "Mostrar mi QR"], images: [#imageLiteral(resourceName: "qr-icon-scan"), #imageLiteral(resourceName: "qr-icon")], title: "Opciones de QR", image: #imageLiteral(resourceName: "qr-icon")) else { return }
        controller.callback = { selected in
            print("Selected option index: \(selected)")
        }
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.permittedArrowDirections = .any
            popoverController.delegate = self
            popoverController.barButtonItem = sender
        }
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func filterButtonPressed(_ sender: UIBarButtonItem) {
        guard let (controller, activityViewController) = storyboard?.createMenu(options: ["Cardiologo", "Otorrinoralinogo", "Otros"], images: nil, title: "Filtrar por", image: nil) else { return }
        controller.callback = { selected in
            print("Selected option index: \(selected)")
        }
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.permittedArrowDirections = .any
            popoverController.delegate = self
            popoverController.barButtonItem = sender
        }
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorCell", for: indexPath) as! DoctorTableViewCell

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.number = "\(indexPath.row)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.title = self.number
    }

}
