import UIKit

class ConfirmStudyIntervals: UIViewController {
    
    struct Data {
        static var chosenStudyTime = ChooseTaskForStudy.Data.timeInterval
        static var chosenBreakTime = ChooseTaskForStudy.Data.breakInterval
        static var chosenSessions = ChooseTaskForStudy.Data.sessions
    }
    
    @IBOutlet weak var studyIntervalLabel: UILabel!
    @IBOutlet weak var breakIntervalLabel: UILabel!
    @IBOutlet weak var sessionsLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        formatWindow()
        
    }
    
    func formatWindow() {
        
        updateButton.layer.cornerRadius = 10.0
        startButton.layer.cornerRadius = 10.0
        
        studyIntervalLabel.text = Data.chosenStudyTime
        breakIntervalLabel.text = Data.chosenBreakTime
        
        if Data.chosenSessions == 0 {
            Data.chosenSessions = 1
        }
        
        sessionsLabel.text = String(Data.chosenSessions)
    }
    
    @IBAction func updateTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toUpdateIntervals", sender: self)
    }
    
    @IBAction func startTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toReminder", sender: self)
    }
}
