import UIKit
import Firebase
import FirebaseFirestore

class StudyFeature: UIViewController {
    
    struct Data {
        static var myEmail = CustomSignUp.Data.email
        static var mySubjects = [String()]
        static var myTasks = [String()]
        static var myMusic = [String()]
        static var myPoints = String()
        
        static var coloredPensBoolean = Bool()
        static var constantPacingBoolean = Bool()
        static var musicBoolean = Bool()
        static var notificationsBoolean = Bool()
    }
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        formatView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveSubjects()
        retrieveTasksForToDoFeature()
        retrieveBooleans()
        retrieveMyPoints()
    }
    
    func formatView() {
        startButton.layer.cornerRadius = 10.0
    }
    
    func retrieveSubjects() {
        db.collection("user").document(Data.myEmail).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                Data.mySubjects = dataDescription!["mySubjects"] as! [String]
            }
            else {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    func retrieveBooleans() {
        db.collection("user").document(Data.myEmail).collection("factors").document("data").getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                Data.coloredPensBoolean = dataDescription!["coloredPensBoolean"] as! Bool
                Data.constantPacingBoolean = dataDescription!["constantPacingBoolean"] as! Bool
                Data.notificationsBoolean = dataDescription!["noNearbyDevicesBoolean"] as! Bool
                Data.musicBoolean = dataDescription!["musicBoolean"] as! Bool
            }
            else {
                print("still...")
            }
        }
    }
    
    func retrieveTasksForToDoFeature() {
        db.collection("user").document(Data.myEmail).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                Data.myTasks = dataDescription!["myTasks"] as! [String]
                print(Data.myTasks)
            }
            else {
                print("Yessir...")
            }
        }
    }
    
    func retrieveMusic() {
        db.collection("user").document(Data.myEmail).collection("factors").document("data").getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                Data.myMusic = dataDescription!["music"] as! [String]
                Data.myMusic.remove(at: 0)
            }
            else {
                print("Yessir...")
            }
        }
    }
    
    func retrieveMyPoints() {
        db.collection("user").document(Data.myEmail).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                Data.myPoints = dataDescription!["points"] as! String
            }
            else {
                print("Document does not exist")
            }
        }
    }
    
    @IBAction func start(_ sender: Any) {
        self.performSegue(withIdentifier: "toChooseSubjectForStudy", sender: self)
    }
    
}
