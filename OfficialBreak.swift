import UIKit

class OfficialBreak: UIViewController {
    
    struct Data {
        static var breakTime = ConfirmStudyIntervals.Data.chosenBreakTime
    }
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var studyButton: UIButton!
    @IBOutlet weak var minutes: UILabel!
    @IBOutlet weak var seconds: UILabel!
    
    let time = Int(Data.breakTime)
    
    var timer: Timer!
    
    var startstop = false
    var started = false
    
    let trackLayer = CAShapeLayer()
    let shapeLayer = CAShapeLayer()
    let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        formatWindow()
        
        formatCircularTimer()
    }
    
    func formatWindow() {
        if Int(Data.breakTime)! <= 10 {
            minutes.text = "0" + Data.breakTime
        }
        
        startButton.layer.cornerRadius = 10.0
        studyButton.layer.cornerRadius = 10.0
    }
    
    func formatCircularTimer() {
        let center = CGPoint(x: view.center.x, y: view.center.y - 14)
        let circularPath = UIBezierPath(arcCenter: center, radius: 115, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.white.cgColor
        trackLayer.lineWidth = 7
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 7
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
        OfficialTimer.Data.totalTimeStudied += time!
    }
    
    @IBAction func enableNotifications(_ sender: Any) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    @IBAction func startButton(_ sender: Any) {
        if started == false {
            started = true
            let timeInSec = Int(Data.breakTime)! * 60
            basicAnimation.toValue = 0.77
            basicAnimation.duration = Double(timeInSec)
            basicAnimation.fillMode = .forwards
            basicAnimation.isRemovedOnCompletion = false
            shapeLayer.add(basicAnimation, forKey: "animation")
        }
        
        
        if startstop == false { //starts timer
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
    
    @IBAction func studyTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
