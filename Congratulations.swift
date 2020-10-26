import UIKit

class Congratulations: UIViewController {
    
    @IBOutlet weak var sessionsDone: UILabel!
    @IBOutlet weak var sessionsTotal: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var totalBreak: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        retrieveSessions()
        retrieveTime()
        retrieveBreak()
    }
    
    func retrieveSessions() {
        sessionsDone.text = String(OfficialTimer.Data.sessionsComplete)
        sessionsTotal.text = String(OfficialTimer.Data.totalSessions)
    }
    
    func retrieveTime() {
        totalTime.text = String(OfficialTimer.Data.totalTimeStudied)
    }
    
    func retrieveBreak() {
        totalBreak.text = String(OfficialBreak.Data.breakTime)
    }
}

