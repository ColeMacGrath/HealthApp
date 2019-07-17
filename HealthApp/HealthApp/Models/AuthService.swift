//
//  AuthService.swift
//  HealthApp
//
//  Created by Moisés Córdova on 7/17/19.
//  Copyright © 2019 Moisés Córdova. All rights reserved.
//

import Foundation
import FirebaseAuth
import RealmSwift

typealias Completion = (_ errorMessage: String?, _ data: AnyObject?) -> Void

class AuthService {
    private static let _shared = AuthService()
    let realm = try? Realm()
    
    static var shared: AuthService {
        return _shared
    }
    
    func login(email: String, password: String, onComplete: Completion?) {
        //Do login
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = (error as NSError?) {
                //Error found
                self.handleFirebaseError(error: error, onComplete: onComplete)
            } else {
                if error == nil {
                    onComplete?(nil, user?.user)
                    //Login correcto
                }
            }
        }
    }
    
    func register(email: String, password: String, patient: Patient, onComplete: Completion?) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error  = (error as NSError?) {
                //User can't be created
                self.handleFirebaseError(error: error, onComplete: onComplete)
            } else {
                if result?.user.uid != nil {
                    let finalPatient = patient
                    finalPatient.uid = (result?.user.uid)!
                    DatabaseService.shared.savePatient(patient: finalPatient)
                    do {
                        try self.realm?.write {
                            self.realm?.add(finalPatient)
                        }
                    } catch {
                        print("Error saving locally")
                    }
                    self.login(email: email, password: password, onComplete: {
                        (message, data) in
                        onComplete?(nil, result?.user)
                    })
                }
            }
        }
    }
    
    func handleFirebaseError(error: NSError, onComplete: Completion?) {
        if let error = AuthErrorCode(rawValue: error.code) {
            switch error {
            case .wrongPassword:
                onComplete?("Wrong password", nil)
            case .invalidEmail, .invalidCredential:
                onComplete?("Invalid Email", nil)
            case .emailAlreadyInUse:
                onComplete?("Email Already in use", nil)
            case .userNotFound:
                onComplete?("User not found", nil)
            case .userDisabled:
                onComplete?("User Disabled", nil)
            case .networkError:
                onComplete?("Network Error", nil)
            case .weakPassword:
                onComplete?("Weak Password", nil)
            default:
                break
            }
        }
    }
}
