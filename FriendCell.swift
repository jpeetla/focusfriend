//
//  FriendCell.swift
//  Final Focus Friend
//
//  Created by focus friend on 8/16/20.
//  Copyright © 2020 focus friend. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var status: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        background.layer.cornerRadius = 10.0
        username.adjustsFontForContentSizeCategory = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
