import UIKit
import Firebase
import FirebaseFirestore


class LifetimeStats: UIViewController {
    
    @IBOutlet weak var totalTimeStudied: UILabel!
    @IBOutlet weak var completedSessions: UILabel!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        showStatistics()
    }
    
    func showStatistics() {
        totalTimeStudied.text = AnalyticsFeature.Data.lifetimeTotalTime
        completedSessions.text = AnalyticsFeature.Data.lifetimeStudySessions
    }
}
