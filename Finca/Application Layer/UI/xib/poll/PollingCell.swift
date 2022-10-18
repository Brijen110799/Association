//
//  PollingCell.swift
//  Finca
//
//  Created by harsh panchal on 02/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class PollingCell: UITableViewCell {

    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var lblPollingQues: UILabel!
    @IBOutlet weak var lbEndDate: UILabel!
    @IBOutlet weak var lblPollingStatus: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var lblStartDateTitle: UILabel!
    @IBOutlet weak var lblEndDateTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

        self.bubbleView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
