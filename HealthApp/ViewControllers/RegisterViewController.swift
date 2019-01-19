import UIKit
import SCLAlertView

class RegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        let mail = emailTextField.text
        let password = passwordTextField.text
        let firstName = firstNameTextField.text
        let lastName = lastNameTextField.text
        
        if mail?.isEmail != nil {
            if password == repeatPasswordTextField.text {
                if password?.isPassword != nil {
                    if firstName?.isName != nil, lastName?.isName != nil {
                        AuthService.shared.register(email: mail!, password: password!, firstName: firstName!, lastName: lastName!, onComplete: { (message, data) in
                            guard message == nil else {
                                let appearance = SCLAlertView.SCLAppearance( showCloseButton: false )
                                let alert = SCLAlertView(appearance: appearance)
                                alert.addButton("OK", action: {})
                                alert.showError("Error", subTitle: message!)
                                return
                            }
                            self.performSegue(withIdentifier: "showMainPageVC", sender: nil)
                        })
                    } else {
                        let appearance = SCLAlertView.SCLAppearance( showCloseButton: false )
                        let alert = SCLAlertView(appearance: appearance)
                        alert.addButton("OK", action: {})
                        alert.showError("Error", subTitle: NSLocalizedString("register.alert.nameError", comment: ""))
                    }
                } else {
                    let appearance = SCLAlertView.SCLAppearance( showCloseButton: false )
                    let alert = SCLAlertView(appearance: appearance)
                    alert.addButton("OK", action: {})
                    alert.showError("Error", subTitle: NSLocalizedString("register.alert.insecurePassword", comment: ""))
                }
            } else {
                let appearance = SCLAlertView.SCLAppearance( showCloseButton: false )
                let alert = SCLAlertView(appearance: appearance)
                alert.addButton("OK", action: {})
                alert.showError("Error", subTitle: NSLocalizedString("register.alert.passwordNotMatch", comment: ""))
            }
        } else {
            let appearance = SCLAlertView.SCLAppearance( showCloseButton: false )
            let alert = SCLAlertView(appearance: appearance)
            alert.addButton("OK", action: {})
            alert.showError("Error", subTitle: NSLocalizedString("register.alert.wrongEmail", comment: ""))
        }
    }
    
    
    
}
