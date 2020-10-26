import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class Settings: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameIn: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var addSubjectsButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        formatWindow()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        view.addGestureRecognizer(tap)
    }
    
    func formatWindow() {
        enterButton.layer.cornerRadius = 10.0
        addSubjectsButton.layer.cornerRadius = 10.0
        signOutButton.layer.cornerRadius = 10.0
        
        db.collection("user").document(HomePage.Data.myEmail).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                self.usernameLabel.text = (dataDescription!["username"] as! String)
            }
            else {
                print("Document does not exist")
            }
        }
    }
    
    func validateFields() -> String? {
        if usernameIn.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return ("Please fill in all fields!")
        }
        
        return nil
    }
    
    func showError(error: String) {
        print(error)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @IBAction func iconsTapped(_ sender: Any) {
        let url = URL(string: "https://icons8.com")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func enterTapped(_ sender: Any) {
        let error = validateFields()
        
        if error != nil {
            showError(error: error!)
        }
        
        else {
            let cleanUsername = usernameIn.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            db.collection("user").document("jpeetla1@gmail.com").setData(["username": cleanUsername], merge: true)
            
            usernameLabel.text = cleanUsername
        }
    }
    
    @IBAction func addSubjectsTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toAddSubjectsinSettings", sender: self)
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            UserDefaults.standard.set("", forKey: "email")
            UserDefaults.standard.set("", forKey: "password")
            UserDefaults.standard.synchronize()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginNavController = storyboard.instantiateViewController(identifier: "LoginController")

            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
        }
        
        catch let err{
            print("This was an error in signing out...", err)
        }
    }
}
