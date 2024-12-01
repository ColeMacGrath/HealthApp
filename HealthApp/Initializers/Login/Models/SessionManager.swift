//
//  SessionManager.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-11-30.
//

import Foundation

@MainActor
@Observable
class SessionManager: ObservableObject {
    static let shared = SessionManager()
    var loginData: LoginResponse? = nil
    
    private init() {
        Task {
            await initialize()
        }
    }
    
    func getUserId() async -> Int? {
        guard let loginData else {
            await logOut()
            return nil
        }
        return loginData.id
    }
    
    func initialize() async {
        self.loginData = await KeychainManager.shared.retrieve(forKey: "loginResponse", as: LoginResponse.self)
    }
    
    func logOut() async {
        await KeychainManager.shared.delete(forKey: "loginResponse")
        loginData = nil
    }
}
