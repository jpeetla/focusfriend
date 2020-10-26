import UIKit
import Firebase
import FirebaseFirestore

class TaskDetails1: UIViewController {
    
    struct Data {
        static var chosenSubjectIndex = Int()
    }
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        formatWindow()
        
        let nib = UINib(nibName: "TaskDetails1Cell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TaskDetails1Cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func formatWindow() {
        tableView.layer.cornerRadius = 10.0
        nextButton.layer.cornerRadius = 10.0
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toSecondTaskInput", sender: self)
    }
}

extension TaskDetails1: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HomePage.Data.mySubjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskDetails1Cell", for: indexPath) as! TaskDetails1Cell
        cell.label.text = HomePage.Data.mySubjects[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Data.chosenSubjectIndex = indexPath.row
    }
}
