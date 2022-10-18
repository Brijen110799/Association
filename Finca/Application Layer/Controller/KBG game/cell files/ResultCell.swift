//
//  ResultCell.swift
//  Finca
//
//  Created by Hardik on 5/8/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class ResultCell: UITableViewCell {

    @IBOutlet weak var lblPlayerName: UILabel!
    @IBOutlet weak var lblUnitNum: UILabel!
    @IBOutlet weak var lblPointsWon: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgPlayerPic: UIImageView!
    @IBOutlet weak var imgCrown: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
