//
//  TaskCell.swift
//  Final Focus Friend
//
//  Created by focus friend on 8/16/20.
//  Copyright © 2020 focus friend. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        overrideUserInterfaceStyle = .light
        
        background.layer.cornerRadius = 10.0
        
        background.layer.borderWidth = 2.0
        background.layer.borderColor = UIColor.darkGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
