//
//  VotingOptionCell.swift
//  Finca
//
//  Created by harsh panchal on 13/08/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class VotingOptionCell: UITableViewCell {

    @IBOutlet weak var lblOptionName: UILabel!
    @IBOutlet weak var viewmain: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.lblOptionName.textColor = selected ? UIColor.white : ColorConstant.primaryColor
        self.viewmain.backgroundColor = selected ? ColorConstant.primaryColor : ColorConstant.primaryColor.withAlphaComponent(0.25)
        // Configure the view for the selected state
    }
    
}
