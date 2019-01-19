import UIKit
import FirebaseAuth
import LocalAuthentication
import SCLAlertView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard Auth.auth().currentUser != nil else {
            performSegue(withIdentifier: "showLoginVC", sender: nil)
            return
        }
        authenticateUser()
        //self.performSegue(withIdentifier: "showMainPageVC", sender: nil)
    }
    
    func authenticateUser() {
        let myContext = LAContext()
        let myLocalizedReasonString = NSLocalizedString("touchId.reason", comment: "")
        
        var authError: NSError?
        if #available(iOS 8.0, macOS 10.12.1, *) {
            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, evaluateError in
                    
                    DispatchQueue.main.async {
                        if success {
                            let appearance = SCLAlertView.SCLAppearance( showCloseButton: false )
                            let alert = SCLAlertView(appearance: appearance)
                            alert.addButton("OK", action: {})
                            alert.showSuccess(NSLocalizedString("login.welcome.title", comment: ""), subTitle: NSLocalizedString("login.welcome.message", comment: ""))
                            self.performSegue(withIdentifier: "showMainPageVC", sender: nil)
                        } else {
                            let appearance = SCLAlertView.SCLAppearance( showCloseButton: false )
                            let alert = SCLAlertView(appearance: appearance)
                            alert.addButton("OK", action: {
                                self.authenticateUser()
                            })
                            alert.showError(NSLocalizedString("login.authError.title", comment: ""), subTitle: NSLocalizedString("login.authError.message", comment: ""))
                        }
                    }
                }
            } else {
                let appearance = SCLAlertView.SCLAppearance( showCloseButton: false )
                let alert = SCLAlertView(appearance: appearance)
                alert.addButton("OK", action: {
                    self.performSegue(withIdentifier: "showMainPageVC", sender: nil)
                })
                alert.showError(NSLocalizedString("login.touchIdError.title", comment: ""), subTitle: NSLocalizedString("login.touchIdError.message", comment: ""))
            }
        } else {
            // Fallback on earlier versions
            
        }
    }

}
