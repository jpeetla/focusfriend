import UIKit
import Firebase
import FirebaseFirestore

class AnalyticsFeature: UIViewController {
    
    struct Data {
        static var chosenSubjectIndex = Int()
        
        static var lifetimeTotalTime = String()
        static var lifetimeStudySessions = String()
        
        static var subjectCompletions = String()
        static var subjectUncompletions = String()
        static var subjectTasks = String()
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var lifetimeButton: UIButton!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        formatWindow()
        
        retrievelifetimeAnalytics()
        
        let nib = UINib(nibName: "AnalyticsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AnalyticsCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func formatWindow() {
        tableView.layer.cornerRadius = 10.0
        viewButton.layer.cornerRadius = 10.0
        lifetimeButton.layer.cornerRadius = 10.0
    }
    
    func retrieveSubjectAnalytics() {
        let subject = HomePage.Data.mySubjects[Data.chosenSubjectIndex]
        db.collection("user").document(HomePage.Data.myEmail).collection("subjects").document(subject).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                Data.subjectCompletions = dataDescription!["completedSessions"] as! String
                Data.subjectUncompletions = dataDescription!["uncompletedSessions"] as! String
                Data.subjectTasks = dataDescription!["completedTasks"] as! String
            }
            else {
                print("Document does not exist")
            }
        }
    }
    
    func retrievelifetimeAnalytics() {
        db.collection("user").document(HomePage.Data.myEmail).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                Data.lifetimeStudySessions = dataDescription!["totalCompletedSessions"] as! String
                Data.lifetimeTotalTime = dataDescription!["totalTimeStudied"] as! String
            }
            else {
                print("Document does not exist")
            }
        }
    }
    
    @IBAction func viewTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toViewAnalytics", sender: self)
    }
    
    @IBAction func lifetimeTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toLifeTime", sender: self)
    }
}

extension AnalyticsFeature: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        HomePage.Data.mySubjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnalyticsCell", for: indexPath) as! AnalyticsCell
        cell.label.text = HomePage.Data.mySubjects[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Data.chosenSubjectIndex = indexPath.row
        retrieveSubjectAnalytics()
    }
}
