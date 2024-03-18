//
//  SessionManager.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-03-17.
//

import Foundation
import UIKit

class SessionManager: Codable {
    static let shared = SessionManager()
    
    private var currentUserSession = "currentUserSession"
    var patientId: Int?
    var doctorId: Int?
    var sessionToken: String?
    
    init(json: Dictionary<String, Any>) {
        guard let token = json["sessionToken"] as? String,
              let id = json["id"] as? Int,
              let rawUserType = json["userType"] as? String else { return }
        let userType = User(rawValue: rawUserType)
        
        self.sessionToken = token
        if userType == .patient {
            patientId = id
        } else {
            doctorId = id
        }
        self.secureSave()
        
    }
    
    private init() {
        guard let savedSession = self.loadSecureSavedSession() else { return }
        self.patientId = savedSession.patientId
        self.doctorId = savedSession.doctorId
        self.sessionToken = savedSession.sessionToken
    }
    
    var isLoggedIn: Bool {
        return self.sessionToken != nil
    }
    
    func secureSave() {
        let encoder = JSONEncoder()
        guard let encodedData = try? encoder.encode(self) else { return }
        let _ = KeychainManager.shared.save(data: encodedData, identifier: self.currentUserSession)
    }
    
    func loadSecureSavedSession() -> SessionManager? {
        guard let retrievedData = KeychainManager.shared.retrieve(identifier: "currentUserSession"),
              let jsonData = try? JSONSerialization.data(withJSONObject: retrievedData, options: []) else {
            self.clearSession()
            return nil
        }
        
        let decoder = JSONDecoder()
        guard let session = try? decoder.decode(SessionManager.self, from: jsonData) else { return nil }
        return session
    }
    
    func clearSession() {
        patientId = nil
        doctorId = nil
        sessionToken = nil
        let _ = KeychainManager.shared.delete(identifier: self.currentUserSession)
    }
    
    func getPatientId() -> Int? {
        guard let patientId else {
            self.logOut()
            return nil
        }
        return patientId
    }
    
    func getDoctorId() -> Int? {
        guard let doctorId else {
            self.logOut()
            return nil
        }
        return doctorId
    }
    
    func getSessionToken() -> String? {
        guard let sessionToken else {
            self.logOut()
            return nil
        }
        return sessionToken
    }
    
    func logOut() {
        self.clearSession()
        DispatchQueue.main.async {
           let initialViewController = UIStoryboard(name: Constants.Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewIdentifiers.initialViewController)
            initialViewController.modalPresentationStyle = .fullScreen
            guard let topViewController = UIViewController.topMostViewController() else { return }
            topViewController.present(initialViewController, animated: false)
        }
    }
}
