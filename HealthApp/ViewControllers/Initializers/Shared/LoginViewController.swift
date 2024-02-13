//
//  LoginViewController.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-02-10.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        Task { @MainActor in
            guard let password = passwordTextField.text,
                  let username = usernameTextField.text else { return }
            let response = await RequestManager.shared.request(endPoint: .login, method: .post, body: [
                "username": username,
                "password": password
            ])
            
            switch response.httpStatusCode {
            case .success:
                guard let body = response.body,
                      KeychainManager.shared.save(dictionary: body, identifier: "session") == .success else {
                    self.showFloatingAlert(text: "Oops! Something went wrong. Try again.", alertType: .error)
                    return
                }
                
                let dashboardViewController = UIStoryboard(name: Constants.Storyboard.tabBar, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewIdentifiers.tabBarViewController)
                dashboardViewController.modalPresentationStyle = .fullScreen
                self.present(dashboardViewController, animated: true)
            case .unauthorized:
                self.showFloatingAlert(text: "Incorrect credentials", alertType: .warning)
            default:
                self.showFloatingAlert(text: "Oops! Something went wrong. Try again.", alertType: .error)
            }
        }
    }
    
    @IBAction func signInWithAppleButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text,
                let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        self.updateLoginButtonState(with: updatedText, isUsernameField: textField == usernameTextField)
        return true
    }
    
    func updateLoginButtonState(with text: String, isUsernameField: Bool) {
        let isUsernameValid = isUsernameField ? text.count >= 3 : (usernameTextField.text?.count ?? 0) >= 3
        let isPasswordValid = !isUsernameField ? text.count >= 6 : (passwordTextField.text?.count ?? 0) >= 6
        self.loginButton.isEnabled = isUsernameValid && isPasswordValid
    }
}
