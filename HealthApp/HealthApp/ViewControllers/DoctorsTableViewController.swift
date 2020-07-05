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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let split = self.splitViewController {
            clearsSelectionOnViewWillAppear = split.isCollapsed
        }
    }
    
    @IBAction func addDoctorButtonPressed(_ sender: UIBarButtonItem) {
        if #available(iOS 13, *) {
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
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func filterButonPressed(_ sender: UIBarButtonItem) {
        #if targetEnvironment(macCatalyst)
        self.createOldMenu(sender: sender)
        #else
        if #available(iOS 13, *) {
            guard let (controller, activityViewController) = storyboard?.createMenu(options: ["Cardiologist", "Otolaryngologist", "Other"], images: nil, title: "Filtrar por", image: nil) else { return }
            controller.callback = { selected in
                print("Selected option index: \(selected)")
            }
            
            if let popoverController = activityViewController.popoverPresentationController {
                popoverController.permittedArrowDirections = .any
                popoverController.delegate = self
                popoverController.barButtonItem = sender
            }
            
            self.present(activityViewController, animated: true, completion: nil)
        } else {
            self.createOldMenu(sender: sender)
        }
        #endif
    }
    
    private func createOldMenu(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Filter by", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cardiologist", style: .default, handler: { (_) in
            //
        }))
        alertController.addAction(UIAlertAction(title: "Otolaryngologist", style: .default, handler: { (_) in
            //
        }))
        alertController.addAction(UIAlertAction(title: "Other", style: .default, handler: { (_) in
            //
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            //
        }))
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.permittedArrowDirections = .any
            popoverController.delegate = self
            popoverController.barButtonItem = sender
        }
        
        self.present(alertController, animated: true)
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorCell", for: indexPath) as! ImageDescriptionCell
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.number = "\(indexPath.row)"
        tableView.deselectRow(at: indexPath, animated: true)
        //self.performSegue(withIdentifier: "showDetailVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailVC" {
            guard let controller = segue.destination as? DoctorProfileViewController else { return }
            controller.title = self.number
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
}
