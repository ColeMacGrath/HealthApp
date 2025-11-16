//
//  SignInView.swift
//  HealthApp
//
//  Created by Moises Cordova on 11/15/2025.
//

import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @Environment(SignInViewModel.self) private var viewModel
    
    var body: some View {
        VStack(spacing: 30) {
            if viewModel.isSignedIn {
                // Signed in state
                VStack(spacing: 20) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.green)
                    
                    Text("Successfully Signed In")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    if let fullName = viewModel.fullName {
                        Text("Name: \(fullName)")
                            .font(.body)
                    }
                    
                    if let email = viewModel.email {
                        Text("Email: \(email)")
                            .font(.body)
                    }
                    
                    if let userID = viewModel.userIdentifier {
                        Text("User ID: \(userID)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    Button(role: .destructive) {
                        viewModel.signOut()
                    } label: {
                        Text("Sign Out")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundStyle(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 20)
                }
            } else {
                // Sign in state
                VStack(spacing: 20) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(.tint)
                    
                    Text("Welcome to HealthApp")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Sign in to continue")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    SignInWithAppleButton(.signIn) { request in
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        viewModel.handleSignInWithApple(result: result)
                    }
                    .signInWithAppleButtonStyle(.black)
                    .frame(height: 50)
                    .padding(.horizontal, 40)
                    .padding(.top, 20)
                }
            }
        }
        .padding()
    }
}

#Preview {
    SignInView()
        .environment(SignInViewModel())
}
