import UIKit
import Firebase
import FirebaseFirestore

class OfficialTimer: UIViewController {
    
    struct Data {
        static var studyTime = ConfirmStudyIntervals.Data.chosenStudyTime
        static var totalSessions = ConfirmStudyIntervals.Data.chosenSessions
        static var sessionsComplete = 1
        
        static var totalTimeStudied = Int()
    }
    
    var myControllers = [UIViewController]()
    
    @IBOutlet weak var sessionsDone: UILabel!
    @IBOutlet weak var totalSessions: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var takeBreakButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var minutes: UILabel!
    @IBOutlet weak var seconds: UILabel!
    @IBOutlet weak var focusToolsButton: UIButton!
    
    let time = Int(Data.studyTime)
    
    var timer: Timer!
    
    var startstop = false
    var started = false
    
    let trackLayer = CAShapeLayer()
    let shapeLayer = CAShapeLayer()
    let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        formatWindow()
        formatCircularTimer()
        
        let meditate = Meditate()
        myControllers.append(meditate)
        
        let fidgetTool = FidgetTool()
        myControllers.append(fidgetTool)
    }
    
    func formatWindow() {
        minutes.text = Data.studyTime
        totalSessions.text = String(ConfirmStudyIntervals.Data.chosenSessions)
        
        startButton.layer.cornerRadius = 10.0
        takeBreakButton.layer.cornerRadius = 10.0
        doneButton.layer.cornerRadius = 10.0
    }
    
    func presentPageVC() {
        guard let first = myControllers.first else { return }
        let vc = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        
        vc.delegate = self
        vc.dataSource = self
        
        vc.setViewControllers([first], direction: .forward, animated: true, completion: nil)
        
        present(vc, animated: true)
    }
    
    func formatCircularTimer() {
        let center = CGPoint(x: view.center.x, y: (view.center.y - 7))
        let circularPath = UIBezierPath(arcCenter: center, radius: 105, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 4
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.systemTeal.cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(trackLayer)
        view.layer.addSublayer(shapeLayer)
    }
    
    @objc func count () {
        var tempSeconds = Int(seconds.text!)!
        var tempMinutes = Int(minutes.text!)!

        if tempMinutes == 0 && tempSeconds == 0 {
            timer.invalidate()
            
            done()
            self.performSegue(withIdentifier: "toOfficialBreak", sender: self)
        }
            
        else if tempMinutes <= 10 {
            minutes.text = "0" + String(tempMinutes)
        }

        if tempSeconds == 0 {
            tempMinutes -= 1
            tempSeconds = 59

            minutes.text = String(tempMinutes)
            seconds.text = String(tempSeconds)
        }

        else if tempSeconds != 0 {
            if tempSeconds <= 10 {
                tempSeconds -= 1
                seconds.text = "0" + String(tempSeconds)
            }
            
            else {
                tempSeconds -= 1
                seconds.text = String(tempSeconds)
            }
        }
    }

    func pause() {
        timer.invalidate()
        basicAnimation.speed = 0.0
    }
    
    func done() {
        Data.sessionsComplete += 1
        Data.totalTimeStudied += time!
    }
    
    @IBAction func muteNotificationsTapped(_ sender: Any) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    @IBAction func startTapped(_ sender: Any) {
        if started == false {
            started = true
            let timeInSec = Int(Data.studyTime)! * 60
            basicAnimation.toValue = 0.77
            basicAnimation.duration = Double(timeInSec)
            basicAnimation.fillMode = .forwards
            basicAnimation.isRemovedOnCompletion = false
            shapeLayer.add(basicAnimation, forKey: "animation")
        }
        
        
        if startstop == false { //starts timer
            basicAnimation.speed = 1
            startstop = true
            
            startButton.backgroundColor = .systemYellow
            startButton.setTitle("stop", for: .normal)
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.count), userInfo: nil, repeats: true)
        }
        
        else { // pauses timer
            startstop = false
            
            pause()
            
            startButton.backgroundColor = .systemGreen
            startButton.setTitle("start", for: .normal)
        }
    }
    
    func storeFinalData() {
        let currentSubject = HomePage.Data.mySubjects[ChooseSubjectForStudy.Data.chosenSubjectIndex]
        let uncompletedSessions = Data.totalSessions - Data.sessionsComplete
        
        var currentSessions = 0
        var currentTime = 0
        var currentPoints = 0
        
        var subjectCurrentCompletions = 0
        var subjectCurrentUncompletions = 0
        var subjectCurrentTasks = 0
        
        var yesTasks = [""]
        
        db.collection("user").document(HomePage.Data.myEmail).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                currentSessions = Int(dataDescription!["totalCompletedSessions"] as! String)!
                currentTime = Int(dataDescription!["totalTimeStudied"] as! String)!
                currentPoints = Int(dataDescription!["points"] as! String)!
                
                currentSessions += Data.sessionsComplete
                currentTime += Data.totalTimeStudied
                currentPoints += 100
                
                let subject = HomePage.Data.mySubjects[ChooseSubjectForStudy.Data.chosenSubjectIndex]
                
                self.db.collection("user").document(HomePage.Data.myEmail).setData(["totalCompletedSessions": String(currentSessions), "totalTimeStudied": String(currentTime), "points": String(currentPoints), "lastSubject": subject, "lastTask": ChooseTaskForStudy.Data.chosenTaskName, "lastSessions": String(Data.sessionsComplete), "lastLength": String(Data.studyTime)], merge: true)
            }
            else {
                print("Document does not exist")
            }
        }
        
        db.collection("user").document(HomePage.Data.myEmail).collection("subjects").document(currentSubject).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                subjectCurrentCompletions = Int(dataDescription!["completedSessions"] as! String)!
                subjectCurrentUncompletions = Int(dataDescription!["uncompletedSessions"] as! String)!
                subjectCurrentTasks = Int(dataDescription!["completedTasks"] as! String)!
                
                subjectCurrentTasks += 1
                subjectCurrentCompletions += Data.sessionsComplete
                subjectCurrentUncompletions += uncompletedSessions
                
                self.db.collection("user").document(HomePage.Data.myEmail).collection("subjects").document(currentSubject).setData(["completedSessions": String(subjectCurrentCompletions), "uncompletedSessions": String(subjectCurrentUncompletions), "completedTasks": String(subjectCurrentTasks)], merge: true)
            }
            else {
                print("Document does not exist")
            }
        }
        
        if ChooseTaskForStudy.Data.isOther == false {
            db.collection("user").document(HomePage.Data.myEmail).getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data()
                    yesTasks = dataDescription!["myTasks"] as! [String]
                    yesTasks.remove(at: ChooseTaskForStudy.Data.chosenTaskIndex)
                    
                    let subject = HomePage.Data.mySubjects[ChooseSubjectForStudy.Data.chosenSubjectIndex]
                    
                    self.db.collection("user").document(HomePage.Data.myEmail).setData(["myTasks": yesTasks], merge: true)
                    
                    self.db.collection("user").document(HomePage.Data.myEmail).collection("subjects").document(subject).collection("tasks").document(ChooseTaskForStudy.Data.chosenTaskName).delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
                }
                    
                else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    @IBAction func focusToolsTapped(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.presentPageVC()
        })
    }
    
    @IBAction func takeBreakTapped(_ sender: Any) {
        let timeElapsed = time! - Int(minutes.text!)!
        Data.totalTimeStudied += timeElapsed
        
        self.performSegue(withIdentifier: "toOfficialBreak", sender: self)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        let timeElapsed = time! - Int(minutes.text!)!
        Data.totalTimeStudied += timeElapsed
        
        storeFinalData() 
        self.performSegue(withIdentifier: "toCongratulations", sender: self)
    }
}

extension OfficialTimer: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
     func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = myControllers.firstIndex(of: viewController), index > 0 else { return nil }
        
        let before = index - 1
        
        return myControllers[before]
     }
     
     func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = myControllers.firstIndex(of: viewController), index < (myControllers.count - 1) else { return nil }
        
        let after = index + 1
        
        return myControllers[after]
     }
    
}
