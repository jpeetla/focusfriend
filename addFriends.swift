import UIKit
import Firebase
import FirebaseFirestore

class addFriends: UIViewController {
    
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        formatWindow()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        view.addGestureRecognizer(tap)
    }
    
    func formatWindow() {
        sendButton.layer.cornerRadius = 10.0
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    func userExists(emailIn: String) -> Bool {
        var flag = false
        
        let users = SocialFeature.Data.users
        
        for email in users {
            if email == emailIn {
                flag = true
            }
        }
        
        return flag
    }
    
    func validateFields() -> String? {
        if usernameInput.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return ("Please fill in all fields!")
        }
        
        let email = usernameInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let flag = userExists(emailIn: email)
        
        if flag == false {
            return ("User does not exist in our database!")
        }
        
        if flag == true {
            return("User successfully added!")
        }
        
        return nil
    }
    
    func showError(error: String) {
        errorLabel.text = error
        errorLabel.alpha = 1
    }
    
    func showSuccess(error: String) {
        errorLabel.textColor = UIColor.systemGreen
        errorLabel.text = error
        errorLabel.alpha = 1
    }
    
    @IBAction func sendTapped(_ sender: Any) {
        let error = validateFields()
        
        if error == "Please fill in all fields!" || error == "User does not exist in our database!" {
            showError(error: error!)
        }
        
        else {
            showSuccess(error: error!)
            let cleanEmail = usernameInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            var cleanUsername = ""
            
            db.collection("user").document(cleanEmail).getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data()
                    cleanUsername = dataDescription!["username"] as! String
                    
                    self.db.collection("user").document(cleanEmail).getDocument { (document, error) in
                        if let document = document, document.exists {
                            let dataDescription = document.data()
                            var cleanFriends = Int(dataDescription!["totalFriends"] as! String)!
                            cleanFriends += 1
                            
                            let userDoc = self.db.collection("user").document(HomePage.Data.myEmail)
                            userDoc.setData(["totalFriends": String(cleanFriends)], merge: true)
                            
                            let newFriend = self.db.collection("user").document(HomePage.Data.myEmail).collection("friends").document(cleanEmail)
                            newFriend.setData(["email": cleanEmail, "username": cleanUsername], merge: true)
                        }
                        else {
                            print("Document does not exist")
                        }
                    }
                }
                else {
                    print("Document does not exist")
                }
            }
        }
    }
}
