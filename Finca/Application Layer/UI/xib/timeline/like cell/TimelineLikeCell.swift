//
//  TimelineLikeCell.swift
//  Finca
//
//  Created by harsh panchal on 27/01/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class TimelineLikeCell: UITableViewCell {
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
