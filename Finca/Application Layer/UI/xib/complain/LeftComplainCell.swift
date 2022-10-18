//
//  LeftComplainCell.swift
//  Finca
//
//  Created by Silverwing Technologies on 11/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class LeftComplainCell: UITableViewCell {
    @IBOutlet var leftView: UIView!
    @IBOutlet var lblDateLeft: UILabel!
    @IBOutlet var lblmsgLeft: UILabel!
    @IBOutlet var heightOfAudio_left: NSLayoutConstraint!
    @IBOutlet weak var ivComplainLeft: UIImageView!
    @IBOutlet var heightOfImage_Left: NSLayoutConstraint!
    
    @IBOutlet weak var imgplayvideo: UIImageView!
    @IBOutlet weak var ivNoch: UIImageView!
    @IBOutlet var lblLeftStatus: UILabel!
    @IBOutlet weak var bImage: UIButton!
    @IBOutlet weak var bAudio: UIButton!

    @IBOutlet weak var playerSlider: UISlider!
    @IBOutlet weak var lbTotalDuration: UILabel!
    @IBOutlet weak var ivImagePlayer: UIImageView!
    @IBOutlet weak var lbCurrentTime: UILabel!
    
    @IBOutlet weak var viewStatus: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
