//
//  LoginModel.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-11-03.
//

import Foundation

@Observable @MainActor
class LoginModel {
    var email: String = String() {
        didSet {
            _ = validateEmail()
        }
    }
    var password: String = String() {
        didSet {
            _ = validatePassword()
        }
    }

    var showLoadingView: Bool = false
    var showAlertView: Bool = false
    var showSignUpView: Bool = false
    var isValidPassword: Bool = true
    var isValidMail: Bool = true
    var isLoginButtonDisabled: Bool {
        return !(validateEmail() && validatePassword())
    }
    
    func login() async {
        showLoadingView = true
        let statusCode = await NetworkManager.shared.login(username: email, password: password)
        
        if statusCode == .ok {
            print("LOGGED IN")
        }
        
        showLoadingView = false
    }
    
    func logOut() {
        
    }
    
    private func validateEmail() -> Bool {
        let emailPattern = #"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}"#
        var evaluation = false
        do {
            if let _ = try email.firstMatch(of: Regex(emailPattern)) {
                evaluation = true
            } else {
                evaluation = false
            }
        } catch {}
        
        isValidMail = evaluation || email.isEmpty
        return isValidMail
    }
    
    private func validatePassword() -> Bool {
        isValidPassword = password.count >= 8 || password.count == 0
        return password.count >= 8
    }
}
