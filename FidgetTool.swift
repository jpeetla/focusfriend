//
//  FidgetTool.swift
//  Final Focus Friend
//
//  Created by focus friend on 9/12/20.
//  Copyright © 2020 focus friend. All rights reserved.
//

import UIKit

class FidgetTool: UIViewController {
    
    let colors = [UIColor.systemRed, UIColor.systemBlue, UIColor.systemGray, UIColor.systemPink, UIColor.systemTeal, UIColor.systemGreen, UIColor.systemIndigo, UIColor.systemOrange, UIColor.systemYellow]

    @IBOutlet weak var tapView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        tapView.layer.cornerRadius = 10.0

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        tapView.addGestureRecognizer(tap)
    }

    @objc func handleTap() {
        let index = Int.random(in: 0..<9)
        
        tapView.backgroundColor = colors[index]
    }
}
