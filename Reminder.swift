import UIKit
import Firebase
import FirebaseFirestore

class Reminder: UIViewController {
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        formatWindow()
    }
    
    func formatWindow() {
        settingsButton.layer.cornerRadius = 10.0
        startButton.layer.cornerRadius = 10.0
    }
    
    @IBAction func settingsTapped(_ sender: Any) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    @IBAction func startTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toOfficialTimer", sender: self)
    }
}
