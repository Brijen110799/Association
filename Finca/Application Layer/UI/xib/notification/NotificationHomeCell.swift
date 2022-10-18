//
//  NotificationHomeCell.swift
//  Finca
//
//  Created by anjali on 23/09/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class NotificationHomeCell: UITableViewCell {

    @IBOutlet weak var bDelete: UIButton!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var imgNotiLogo: UIImageView!
    
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var bubbleView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        bubbleView.makeBubbleView()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
