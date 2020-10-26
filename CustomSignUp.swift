import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class CustomSignUp: UIViewController {
    
    struct Data {
        static var email = String()
        static var username = String()
    }
    
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBOutlet weak var termsAndConditionsButton: UIButton!

    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatWindow()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        view.addGestureRecognizer(tap)
    }
    
    func formatWindow() {
        overrideUserInterfaceStyle = .light
        
        createAccountButton.layer.cornerRadius = 10.0
        privacyPolicyButton.layer.cornerRadius = 10.0
        termsAndConditionsButton.layer.cornerRadius = 10.0
    }
    
    func validateFields() -> String? {
        if usernameInput.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordInput.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailInput.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return ("Please fill in all fields!")
        }
        
        return nil
    }
    
    func showError(error: String) {
        let alert = UIAlertController(title: "focus friend", message: error, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func createUser(username: String, email: String) {
        let userInfo = self.db.collection("user").document(email)
        
        userInfo.setData(["email": email, "username": username, "points": "0", "totalTimeStudied": "0", "totalCompletedSessions": "0"], merge: true)
        
        HomePage.Data.myPoints = "0"
        HomePage.Data.totalFriends = "0"
        
        HomePage.Data.lastSubject = "None"
        HomePage.Data.lastTask = "None"
        HomePage.Data.lastSessions = "0"
        HomePage.Data.lastLength = "0"
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @IBAction func createAccountTapped(_ sender: Any) {
        let error = validateFields()
        
        if error != nil {
            showError(error: error!)
        }
        
        else {
            let cleanUsername = usernameInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanEmail = emailInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanPassword = passwordInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Data.username = cleanUsername
            Data.email = cleanEmail
            
            Auth.auth().createUser(withEmail: cleanEmail, password: cleanPassword, completion: { (result, error) in
                if error != nil {
                    self.showError(error: error!.localizedDescription)
                }
                
                else {
                    self.createUser(username: cleanUsername, email: cleanEmail)
                    
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    UserDefaults.standard.set(cleanEmail, forKey: "email")
                    UserDefaults.standard.set(cleanPassword, forKey: "password")
                    UserDefaults.standard.synchronize()
                    
                    self.performSegue(withIdentifier: "startSurvey", sender: self)
                }
            })
        }
    }
    
    @IBAction func privacyPolicy(_ sender: Any) {
        let url = URL(string: "https://focusfriend01.wixsite.com/focus-friend/privacy-policy")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func termsAndConditions(_ sender: Any) {
        let url = URL(string: "https://focusfriend01.wixsite.com/focus-friend/terms-and-conditions-1")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func moveToSignIn(_ sender: Any) {
        self.performSegue(withIdentifier: "fromSignUptoSignIn", sender: self)
    }
}
