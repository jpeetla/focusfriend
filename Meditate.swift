//
//  Meditate.swift
//  Final Focus Friend
//
//  Created by focus friend on 9/12/20.
//  Copyright © 2020 focus friend. All rights reserved.
//

import UIKit

class Meditate: UIViewController {

    @IBOutlet weak var timerText: UILabel!
    @IBOutlet weak var breatheText: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    var timer: Timer!
    
    var started = false
    
    var InorOut = false //false means breathing in  || true means breathing out
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light

        formatWindow()
    }
    
    func formatWindow() {
        startButton.layer.cornerRadius = 10.0
    }
    
    @objc func count () {
        var tempSeconds = Int(timerText.text!)!

        if tempSeconds == 0 {
            if InorOut == false {
                InorOut = true
                
                breatheText.text = "breathe out!"
            }
            
            else {
                InorOut = false
                
                breatheText.text = "breathe in!"
            }
            
            timerText.text = "7"
        }

        else if tempSeconds != 0 {
            tempSeconds -= 1
            timerText.text = String(tempSeconds)
        }
    }
    
    func switchInOut() {
        if InorOut == false {
            InorOut = true
            
            breatheText.text = "breathe out!"
        }
        
        if InorOut == true {
            InorOut = false
            
            breatheText.text = "breathe in!"
        }
    }
    
    @IBAction func startTapped(_ sender: Any) {
        if started == true {
            started = false
            
            timer.invalidate()
            
            timerText.text = "7"
            
            startButton.setTitle("start", for: .normal)
        }
        
        
        if started == false { //starts timer
            started = true
            
            startButton.setTitle("reset", for: .normal)
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.count), userInfo: nil, repeats: true)
        }
    }
    
}
