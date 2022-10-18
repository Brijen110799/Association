//
//  SurveyCell.swift
//  Finca
//
//  Created by Silverwing-macmini1 on 26/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class SurveyCell: UITableViewCell {

    @IBOutlet weak var widthOfStatus: NSLayoutConstraint!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSurveyDes: UILabel!
    @IBOutlet weak var lblSurveyTitle: UILabel!
    
    @IBOutlet weak var lbDescption: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bubbleView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
