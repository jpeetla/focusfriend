import UIKit
import Firebase
import FirebaseFirestore

class viewAnalytics: UIViewController {
    
    @IBOutlet weak var completedSessions: UILabel!
    @IBOutlet weak var uncompletedSessions: UILabel!
    @IBOutlet weak var tasksCompleted: UILabel!
    
    override func viewDidLoad() {
        
        overrideUserInterfaceStyle = .light
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveTaskStatistics()
    }
    
    func retrieveTaskStatistics() {
        if AnalyticsFeature.Data.subjectCompletions == "" {
            AnalyticsFeature.Data.subjectCompletions = "0"
        }
        
        if AnalyticsFeature.Data.subjectUncompletions == "" {
            AnalyticsFeature.Data.subjectUncompletions = "0"
        }
        
        if AnalyticsFeature.Data.subjectTasks == "" {
            AnalyticsFeature.Data.subjectTasks = "0"
        }
        
        completedSessions.text = AnalyticsFeature.Data.subjectCompletions
        uncompletedSessions.text = AnalyticsFeature.Data.subjectUncompletions
        tasksCompleted.text = AnalyticsFeature.Data.subjectTasks
        
    }
}
