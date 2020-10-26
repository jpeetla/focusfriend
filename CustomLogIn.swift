import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class CustomLogIn: UIViewController {
    
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var signInButton: UIButton!
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
        
        signInButton.layer.cornerRadius = 10.0
        privacyPolicyButton.layer.cornerRadius = 10.0
        termsAndConditionsButton.layer.cornerRadius = 10.0
    }
    
    func validateFields() -> String? {
        if passwordInput.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
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
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        let error = validateFields()
        
        if error != nil {
            showError(error: error!)
        }
        
        else {
            let cleanEmail = emailInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanPassword = passwordInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().signIn(withEmail: cleanEmail, password: cleanPassword) { (result, error) in
                if error != nil {
                    self.showError(error: error!.localizedDescription)
                }
                
                else {
                    CustomSignUp.Data.email = cleanEmail
                    
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    UserDefaults.standard.set(cleanEmail, forKey: "email")
                    UserDefaults.standard.set(cleanPassword, forKey: "password")
                    UserDefaults.standard.synchronize()
                    
                    self.db.collection("user").document(CustomSignUp.Data.email).getDocument { (document, error) in
                        if let document = document, document.exists {
                            let dataDescription = document.data()
                            
                            HomePage.Data.myTasks = dataDescription!["myTasks"] as! [String]
                            HomePage.Data.myPoints = dataDescription!["points"] as! String
                            HomePage.Data.totalFriends = dataDescription!["totalFriends"] as! String
                            
                            HomePage.Data.lastSubject = dataDescription!["lastSubject"] as! String
                            HomePage.Data.lastTask = dataDescription!["lastTask"] as! String
                            HomePage.Data.lastSessions = dataDescription!["lastSessions"] as! String
                            HomePage.Data.lastLength = dataDescription!["lastLength"] as! String
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let mainTabBarController = storyboard.instantiateViewController(identifier: "HomeController")
                            
                            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                        }
                        else {
                            print("Error retrieving tasks...")
                        }
                    }
                }
            }
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
    
    @IBAction func moveToSignUp(_ sender: Any) {
        self.performSegue(withIdentifier: "fromSignIntoSignUp", sender: self)
    }
}
