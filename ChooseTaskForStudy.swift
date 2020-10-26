import UIKit
import Firebase
import FirebaseFirestore

class ChooseTaskForStudy: UIViewController {
    
    struct Data {
        static var chosenTaskIndex = -1
        static var chosenTaskName = String()
        static var sessions = Int()
        static var timeInterval = String()
        static var breakInterval = String()
        static var isOther = Bool()
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        formatWindow()
        
        let nib = UINib(nibName: "StudyFeatureTwo", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "StudyFeatureTwo")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func formatWindow() {
        nextButton.layer.cornerRadius = 10.0
        tableView.layer.cornerRadius = 10.0
    }
    
    func showError(errorMessage: String) {
        print(errorMessage)
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        if Data.chosenTaskIndex == -1 {
            showError(errorMessage: "Please choose a task to continue!")
        }

        else {
            self.performSegue(withIdentifier: "toConfirmStudyIntervals", sender: self)
        }
    }
}

extension ChooseTaskForStudy: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChooseSubjectForStudy.Data.myTasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudyFeatureTwo", for: indexPath) as! StudyFeatureTwo
        cell.label.text = ChooseSubjectForStudy.Data.myTasks[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Data.chosenTaskIndex = indexPath.row
        Data.chosenTaskName = ChooseSubjectForStudy.Data.myTasks[Data.chosenTaskIndex]
        
        let subject = HomePage.Data.mySubjects[ChooseSubjectForStudy.Data.chosenSubjectIndex]
        let subjectDoc = db.collection("user").document(HomePage.Data.myEmail).collection("subjects").document(subject)
        
        subjectDoc.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                Data.timeInterval = dataDescription!["timeInterval"] as! String
                Data.breakInterval = dataDescription!["breakInterval"] as! String
            }
            else {
                print("Task Document does not exist")
            }
        }
        
        let taskDoc = db.collection("user").document(HomePage.Data.myEmail).collection("subjects").document(subject).collection("tasks").document(Data.chosenTaskName)
        taskDoc.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                Data.sessions = dataDescription!["sessions"] as! Int
            }
            else {
                Data.isOther = true
                print("Task Document does not exist")
            }
        }
    }
}
