//
//  ReceivedLocationGroupCell.swift
//  Finca
//
//  Created by harsh panchal on 25/05/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class ReceivedLocationGroupCell: UITableViewCell {
    @IBOutlet weak var lbSenderName: UILabel!
    @IBOutlet weak var ivImageLocation: UIImageView!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var bLocation: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMaxXMaxYCorner]
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
