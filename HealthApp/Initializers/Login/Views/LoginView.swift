//
//  LoginView.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-10-20.
//

import SwiftUI

struct LoginView: View {
    @State private var showSignupView = false
    @Environment(LoginModel.self) private var model
    
    var body: some View {
        @Bindable var model = model
        ScrollView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Welcome")
                        .foregroundStyle(.accent)
                    Text("Back!")
                }
                .bold()
                .font(.largeTitle)
                .padding(.vertical)
                
                Text("Start by logging in and stay connect with your health and your doctors in a few touches.")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom)
                
                OutlinedTextField(text: $model.email, placeholder: "Enter your mail", image: Image(systemName: "envelope.fill"))
                    .padding(.vertical)
                OutlinedTextField(text: $model.password, isSecure: true, placeholder: "Enter your password", image: Image(systemName: "lock.fill"))
                
                Button {
                    
                } label: {
                    HStack {
                        Spacer()
                        Text("Forgot password")
                            .bold()
                            .padding()
                    }
                }
                
                
                Button("Login") {
                    Task {
                        await model.login()
                    }
                }
                .CapsuleButtonStyle()
                
                HStack {
                    Rectangle()
                        .frame(height: 1.0)
                    Text("Or")
                    Rectangle()
                        .frame(height: 1.0)
                }
                .padding()
                .foregroundStyle(.secondary)
                
                
                
                Button("Sign in With Apple") {
                    
                }
                .CapsuleButtonStyle(backgroundColor: Color(.label), fontColor: Color(.systemBackground), image: Image(systemName: "apple.logo"), imageForegroundColor: Color(.systemBackground))
                
                Spacer()
                
            }
            .padding()
            .sheet(isPresented: $showSignupView) {
                SignupView()
            }
            
            
           
        }
        .scrollBounceBehavior(.basedOnSize, axes: .vertical)
        .loadingView(isPresented: $model.showLoadingView, message: "Loggin in", fullScreen: false)
        
        HStack {
            Text("Don't have an account")
            Button {
                showSignupView = true
            } label: {
                Text("Create One")
                    .bold()
            }
            
        }.padding(.bottom)
    }
}

struct OutlinedTextField: View {
    @Binding var text: String
    var isSecure: Bool = false
    var placeholder: String
    var image: Image
    
    init(text: Binding<String>, isSecure: Bool = false, placeholder: String = .empty, image: Image) {
        self._text = text
        self.isSecure = isSecure
        self.placeholder = placeholder
        self.image = image
    }
    
    var body: some View {
        HStack {
            image
                .padding(.leading)
                .frame(width: 20.0)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .padding()
            } else {
                TextField(placeholder, text: $text)
                    .padding()
            }
        }
        .background(RoundedRectangle(cornerRadius: 10)
            .stroke(.secondary, lineWidth: 0.5))
    }
}


#Preview {
    LoginView()
        .environment(LoginModel())
}

