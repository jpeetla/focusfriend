import UIKit

class UpdateStudyIntervals: UIViewController {
    
    @IBOutlet weak var studyIntervalInput: UITextField!
    @IBOutlet weak var breakIntervalInput: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        view.addGestureRecognizer(tap)
    }
    
    func formatWindow() {
        enterButton.layer.cornerRadius = 10.0
    }
    
    func validateFields() -> String? {
        if studyIntervalInput.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || breakIntervalInput.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return ("Please fill in all fields!")
        }
        
        return nil
    }
    
    func showError(error: String) {
        print(error)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    func updateTimes() {
        let cleanStudyTime = studyIntervalInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanBreakTime = breakIntervalInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        ConfirmStudyIntervals.Data.chosenStudyTime = cleanStudyTime
        ConfirmStudyIntervals.Data.chosenBreakTime = cleanBreakTime
    }
    
    @IBAction func enterTapped(_ sender: Any) {
        let error = validateFields()
        
        if error != nil {
            showError(error: error!)
        }
        
        else {
            updateTimes()
            self.performSegue(withIdentifier: "fromUpdatetoConfirm", sender: self)
        }
    }
}
