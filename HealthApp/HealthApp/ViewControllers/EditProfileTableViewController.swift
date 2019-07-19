//
//  EditProfileTableViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 7/18/19.
//  Copyright © 2019 Moisés Córdova. All rights reserved.
//

import UIKit
import RealmSwift

class EditProfileViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var patient: Patient?
    let realm = try? Realm()
    var imagePicker = UIImagePickerController()
    
    var firstNameTextField: UITextField!
    var lastNameTextField: UITextField!
    var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.removeExtraLines()
        imagePicker.delegate = self
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if firstNameTextField.text != "", lastNameTextField.text != "", profileImageView.image != nil {
            do {
                try realm?.write {
                    patient?.firstName = firstNameTextField.text!
                    patient?.lastName = lastNameTextField.text!
                    patient?.dataProfilePicture = profileImageView.image?.pngData()
                }
            } catch {
                print("Error writting: \(error)")
            }
            
            NotificationCenter.default.post(name: NSNotification.Name("UpdateTableInfo"), object: nil)
            patient?.saveBasicInfoInFirebase()
            saveProfileImageInFirebase()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func saveProfileImageInFirebase() {
        if patient != nil {
            guard let userUID = patient?.uid else { return }
            var imageData: Data?
            imageData = patient?.dataProfilePicture ?? profileImageView.image?.pngData()
            
            if let data = imageData {
                let imageName = "Profile\(userUID).jpg"
                let ref = DatabaseService.shared.imageStorageRef.child("Patient").child("ProfilePicture").child(imageName)
                _ = ref.putData(data, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print("Error al subir la imagen")
                    } else {
                        ref.downloadURL(completion: { (url, error) in
                            if error != nil {
                                print("Error interno al subir la imagen: \(String(describing: error?.localizedDescription))")
                                return
                            }
                            DatabaseService.shared.savePictureRef(uid: userUID, url: url!)
                        })
                    }
                })
                
            } else {
                print("No se pudo crear la imagegData o la url")
            }
        }
    }
    
    func chooseImage() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGalery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGalery() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
}

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! ImageTableViewCell
            self.profileImageView = cell.profileImage
            if let image = patient?.profilePicture {
                cell.profileImage.image = image
            } else {
                cell.profileImage.image = UIImage(named: "profile-placeholder")
            }
            
            cell.selectionStyle = .none
            return cell
            
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "placeholderCell", for: indexPath)
            cell.textLabel?.text = "Sign Out"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont(name: "Helvetica", size: 25.0)
            cell.textLabel?.textColor = UIColor.red
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "placeholderCell", for: indexPath) as! PlaceholderTableViewCell
            cell.selectionStyle = .none
            switch indexPath.row {
            case 1:
                self.firstNameTextField = cell.textField
                cell.label.text = "First Name"
                cell.textField.placeholder = patient?.firstName ?? ""
            default:
                self.lastNameTextField = cell.textField
                cell.label.text = "Last Name"
                cell.textField.placeholder = patient?.lastName ?? ""
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 70.0
        if indexPath.row == 0 {
            height = 150.0
        } else if indexPath.row == 7 {
            height = 270.0
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            chooseImage()
        }
        if indexPath.row == 3 {
            do {
                try realm?.write {
                    realm?.deleteAll()
                }
                try AuthService.shared.fireabseAuth.signOut()
                self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
            } catch {
                print ("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            profileImageView.image = image
            let indexPath = IndexPath(row: 0, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as! ImageTableViewCell
            cell.profileImage.image = profileImageView.image
        }
        
        self.dismiss(animated: true)
    }
    
}
