//
//  SendLocationCell.swift
//  Finca
//
//  Created by Silverwing Technologies on 18/05/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class SendLocationCell: UITableViewCell {
    @IBOutlet weak var ivImageLocation: UIImageView!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet var imgTick: UIImageView!
    @IBOutlet weak var bLocation: UIButton!
    @IBOutlet weak var viewDelete: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
