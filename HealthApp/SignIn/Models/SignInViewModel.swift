//
//  SignInViewModel.swift
//  HealthApp
//
//  Created by Moises Cordova on 11/15/2025.
//

import Foundation
import AuthenticationServices

@Observable
final class SignInViewModel {
    var errorMessage: String?
    var isSignedIn: Bool = false
    var userIdentifier: String?
    var fullName: String?
    var email: String?
    
    func handleSignInWithApple(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            handleAuthorization(authorization)
        case .failure(let error):
            handleError(error)
        }
    }
    
    private func handleAuthorization(_ authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            errorMessage = "Failed to get Apple ID credential"
            return
        }
        
        userIdentifier = appleIDCredential.user
        
        // Get full name if available (only provided on first sign in)
        if let givenName = appleIDCredential.fullName?.givenName,
           let familyName = appleIDCredential.fullName?.familyName {
            fullName = "\(givenName) \(familyName)"
        } else if let givenName = appleIDCredential.fullName?.givenName {
            fullName = givenName
        }
        
        // Get email if available
        email = appleIDCredential.email
        
        // Print the values as requested
        print("✅ Sign In Successful!")
        print("User ID: \(userIdentifier ?? "N/A")")
        print("Full Name: \(fullName ?? "N/A (only available on first sign in)")")
        print("Email: \(email ?? "N/A (only available on first sign in)")")
        
        isSignedIn = true
        errorMessage = nil
    }
    
    private func handleError(_ error: Error) {
        let authError = error as? ASAuthorizationError
        
        switch authError?.code {
        case .canceled:
            errorMessage = "Sign in was canceled"
        case .failed:
            errorMessage = "Sign in failed"
        case .invalidResponse:
            errorMessage = "Invalid response from Apple"
        case .notHandled:
            errorMessage = "Sign in request was not handled"
        case .unknown:
            errorMessage = "An unknown error occurred"
        default:
            errorMessage = error.localizedDescription
        }
        
        print("❌ Sign In Error: \(errorMessage ?? "Unknown error")")
    }
    
    func signOut() {
        userIdentifier = nil
        fullName = nil
        email = nil
        isSignedIn = false
        errorMessage = nil
        print("🔓 User signed out")
    }
}
