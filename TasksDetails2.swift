import UIKit
import Firebase
import FirebaseFirestore

class TaskDetails2: UIViewController {
    
    @IBOutlet weak var taskNameInput: UITextField!
    @IBOutlet weak var timeNeededInput: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var success: UILabel!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        view.addGestureRecognizer(tap)
        
        formatWindow()
    }
    
    func formatWindow() {
        success.alpha = 0
        enterButton.layer.cornerRadius = 10.0
        taskNameInput.autocorrectionType = .no
        timeNeededInput.autocorrectionType = .no
    }
    
    func validateFields() -> String? {
        if taskNameInput.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            timeNeededInput.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
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
    
    func createSessions(totalTime: Int, taskName: String) {
        let subject = HomePage.Data.mySubjects[TaskDetails1.Data.chosenSubjectIndex]
        var timeInterval = 0
        
        let taskDoc = db.collection("user").document(CustomSignUp.Data.email).collection("subjects").document(subject)
        
        taskDoc.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                timeInterval = Int(dataDescription!["timeInterval"] as! String)!
                
                var sessions = Int(totalTime / timeInterval)
                
                if sessions == 0 {
                    sessions = 1
                }
                
                let task = self.db.collection("user").document(CustomSignUp.Data.email).collection("subjects").document(subject).collection("tasks").document(taskName)
                task.setData(["sessions": sessions], merge: true)
            }
            else {
                print("Document does not exist")
            }
        }
    }
    
    func retrieveExistingTasks(newTask: String) {
        let userDoc = db.collection("user").document(CustomSignUp.Data.email)
        var myTasks: [String] = [""]
        
        userDoc.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                myTasks = dataDescription!["myTasks"] as! [String]
                myTasks.append(newTask)
                
                let user = self.db.collection("user").document(CustomSignUp.Data.email)
                user.setData(["myTasks": myTasks], merge: true)
            }
            else {
                print("Document does not exist")
            }
        }
    }
    
    func storeTask() {
        let cleanTaskName = taskNameInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanTimeNeeded = Int(timeNeededInput.text!.trimmingCharacters(in: .whitespacesAndNewlines))
        let subject = HomePage.Data.mySubjects[TaskDetails1.Data.chosenSubjectIndex]
        
        let taskDoc = db.collection("user").document(CustomSignUp.Data.email).collection("subjects").document(subject).collection("tasks").document(cleanTaskName)
        taskDoc.setData(["timeNeeded": cleanTimeNeeded!, "taskName": cleanTaskName], merge: true)
        
        retrieveExistingTasks(newTask: cleanTaskName)
        createSessions(totalTime: cleanTimeNeeded!, taskName: cleanTaskName)
    }

    @IBAction func enterTapped(_ sender: Any) {
        let error = validateFields()
        
        if error != nil {
            showError(error: error!)
        }
        
        else {
            self.storeTask()
            success.alpha = 1
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
