import UIKit
import Firebase
import FirebaseFirestore

class AddSubjectinSettings: UIViewController {
    
    @IBOutlet weak var subjectIn: UITextField!
    @IBOutlet weak var timeIn: UITextField!
    @IBOutlet weak var breakIn: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var success: UILabel!
    
    let db = Firestore.firestore()
    
    var selectedTime: String?
    var selectedBreak: String?
    
    let times = ["5", "10", "15", "25", "30", "45", "60", "75", "90", "105", "120"]
    let breaks = ["1", "2", "3", "4", "5", "10", "15", "20", "25", "30", "35", "45", "50", "55", "60", "75", "90", "105", "120"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        formatWindow()
        createPickerView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        view.addGestureRecognizer(tap)
    }
    
    func formatWindow() {
        success.alpha = 0
        enterButton.layer.cornerRadius = 10.0
    }
    
    func createPickerView() {
        let timePicker = UIPickerView()
        let breakPicker = UIPickerView()
        
        timePicker.tag = 1
        breakPicker.tag = 0
        
        timePicker.delegate = self
        breakPicker.delegate = self
        
        timeIn.inputView = timePicker
        breakIn.inputView = breakPicker
    }
    
    func validateFields() -> String? {
        if subjectIn.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            timeIn.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            breakIn.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return ("Please fill in all fields!")
        }
        
        return nil
    }
    
    func showError(error: String) {
        errorLabel.text = error
        errorLabel.alpha = 1
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @IBAction func enterTapped(_ sender: Any) {
        let cleanEmail = HomePage.Data.myEmail
        let cleanSubject = subjectIn.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanTime = timeIn.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanBreak = breakIn.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let user = db.collection("user").document(cleanEmail).collection("subjects").document(cleanSubject)
        user.setData(["subjectName": cleanSubject, "timeInterval": cleanTime, "breakInterval": cleanBreak, "completedSessions": "0", "uncompletedSessions": "0", "completedTasks": "0"], merge: true)
        
        db.collection("user").document(cleanEmail).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                var mySubjects = dataDescription!["mySubjects"] as! [String]
                mySubjects.append(cleanSubject)
                
                self.db.collection("user").document(cleanEmail).setData(["mySubjects": mySubjects], merge: true)
                
                self.success.alpha = 1
            }
            else {
                print("Document does not exist")
            }
        }
    }
}

extension AddSubjectinSettings: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return times.count
        }
        
        else {
            return breaks.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return times[row]
        }
        
        else {
            return breaks[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            selectedTime = times[row]
            timeIn.text = selectedTime
        }
        
        else {
            selectedBreak = breaks[row]
            breakIn.text = selectedBreak
        }
    }
}
