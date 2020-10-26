import UIKit
import Firebase
import FirebaseFirestore

class ChooseSubjectForStudy: UIViewController {
    
    struct Data {
        static var chosenSubjectIndex = -1
        static var myTasks = ["Other"]
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    var done = false
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        formatView()
        
        let nib = UINib(nibName: "SubjectCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SubjectCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func formatView() {
        tableView.layer.cornerRadius = 10.0
        nextButton.layer.cornerRadius = 10.0
    }
    
    func showError(errorMessage: String) {
        print(errorMessage)
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        if Data.chosenSubjectIndex == -1 {
            showError(errorMessage: "Please choose a task to continue!")
        }

        else {
            self.performSegue(withIdentifier: "toChooseTaskForStudy", sender: self)
        }
    }
}

extension ChooseSubjectForStudy: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        HomePage.Data.mySubjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectCell", for: indexPath) as! SubjectCell
        cell.label.text = HomePage.Data.mySubjects[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectCell", for: indexPath) as! SubjectCell
        cell.background.backgroundColor = UIColor.lightGray
        
        Data.chosenSubjectIndex = indexPath.row
        
        Data.myTasks = ["Other"]
        let tempSubject = HomePage.Data.mySubjects[Data.chosenSubjectIndex]
        let taskDoc = db.collection("user").document(HomePage.Data.myEmail).collection("subjects").document(tempSubject).collection("tasks")
        
        taskDoc.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                return
            }
            
            for document in snapshot.documents {
                let taskName = document.get("taskName") as! String
                Data.myTasks.append(taskName)
            }
        }
        
        print(Data.myTasks)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        Data.myTasks = ["Other"]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectCell", for: indexPath) as! SubjectCell
        cell.background.backgroundColor = UIColor.systemTeal
    }
}
