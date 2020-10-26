import UIKit
import Firebase
import FirebaseFirestore

class HomePage: UIViewController {
    
    struct Data {
        static var myEmail = CustomSignUp.Data.email
        static var myTasks = [String()]
        static var mySubjects = [String()]
        
        static var myPoints = String()
        
        static var coloredPensBoolean = Bool()
        static var constantPacingBoolean = Bool()
        static var musicBoolean = Bool()
        static var notificationsBoolean = Bool()
        static var musicList = [String()]
        
        static var totalFriends = String()
        static var lastSubject = String()
        static var lastTask = String()
        static var lastSessions = String()
        static var lastLength = String()
    }
    
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var todoTableView: UITableView!
    @IBOutlet weak var recentActivityView: UIView!
    @IBOutlet weak var thirdView: UIView!
    
    @IBOutlet weak var lastSubject: UILabel!
    @IBOutlet weak var lastTask: UILabel!
    @IBOutlet weak var lastSessions: UILabel!
    @IBOutlet weak var lastLength: UILabel!
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var totalFriends: UILabel!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        formatWindow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadTasks()
        retrieveSubjects()
        retrieveBooleans()
        retrieveFriends()
        
        formatWindow()
    }
    
    func formatWindow() {
        let nib = UINib(nibName: "TaskCell", bundle: nil)
        todoTableView.register(nib, forCellReuseIdentifier: "TaskCell")
        todoTableView.dataSource = self
        todoTableView.delegate = self
        
        todoTableView.rowHeight = 50.0
        
        recentActivityView.layer.borderWidth = 2.0
        recentActivityView.layer.borderColor = UIColor.darkGray.cgColor
        
        thirdView.layer.borderWidth = 2.0
        thirdView.layer.borderColor = UIColor.darkGray.cgColor
        
        todoTableView.layer.cornerRadius = 10.0
        recentActivityView.layer.cornerRadius = 10.0
        thirdView.layer.cornerRadius = 10.0
        
        points.text = Data.myPoints
        totalFriends.text = Data.totalFriends
        lastSubject.text = Data.lastSubject
        lastTask.text = Data.lastTask
        lastSessions.text = Data.lastSessions
        lastLength.text = Data.lastLength
    }
    
    func reloadTasks() {
        db.collection("user").document(CustomSignUp.Data.email).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                Data.myTasks = dataDescription!["myTasks"] as! [String]
                Data.myPoints = dataDescription!["points"] as! String
                Data.totalFriends = dataDescription!["totalFriends"] as! String
                
                HomePage.Data.lastSubject = dataDescription!["lastSubject"] as! String
                HomePage.Data.lastTask = dataDescription!["lastTask"] as! String
                HomePage.Data.lastSessions = dataDescription!["lastSessions"] as! String
                HomePage.Data.lastLength = dataDescription!["lastLength"] as! String
                
                if Data.myTasks[0] == "" {
                    Data.myTasks.remove(at: 0)
                }
                
                self.todoTableView.reloadData()
            }
            else {
                print("Error retrieving tasks...")
            }
        }
    }
    
    func retrieveSubjects() {
        db.collection("user").document(Data.myEmail).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                Data.mySubjects = dataDescription!["mySubjects"] as! [String]
            }
            else {
                print("Error retrieving subjects...")
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
                Data.musicList = dataDescription!["music"] as! [String]
            }
            else {
                print("Error retrieving booleans...")
            }
        }
    }
    
    func retrieveFriends() {
        SocialFeature.Data.myFriends = [""]
        SocialFeature.Data.myFriendsPoints = [""]
        db.collection("user").document(HomePage.Data.myEmail).collection("friends").getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error \(error!)")
                return
            }
            for document in snapshot.documents {
                let username = document.get("username") as! String
                let tempEmail = document.get("email") as! String //Getting a nil error

                self.db.collection("user").document(tempEmail).getDocument { (document, error) in
                    if let document = document, document.exists {
                        let dataDescription = document.data()
                        
                        let points = dataDescription!["points"] as! String
                        
                        SocialFeature.Data.myFriends.append(username)
                        SocialFeature.Data.myFriendsPoints.append(points)
                    }
                    else {
                        print("Error retrieving booleans...")
                    }
                }
            }
        }
    }
    
    @IBAction func addTaskTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toFirstTaskInput", sender: self)
    }
    
    @IBAction func settingsTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toSettings", sender: self)
    }
    @IBAction func linkTapped(_ sender: Any) {
        let url = URL(string: "https://focusfriend01.wixsite.com/focus-friend")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension HomePage: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.myTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        cell.label.text = Data.myTasks[indexPath.row]
        return cell
    }
}
