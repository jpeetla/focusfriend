//
//  StudyFeatureTwo.swift
//  Final Focus Friend
//
//  Created by focus friend on 8/16/20.
//  Copyright © 2020 focus friend. All rights reserved.
//

import UIKit

class StudyFeatureTwo: UITableViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        background.layer.cornerRadius = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        background.backgroundColor = selected ? .lightGray : .systemTeal
    }
    
}
