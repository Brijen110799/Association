//
//  FinbookCommonCell.swift
//  Finca
//
//  Created by harsh panchal on 18/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class FinbookCommonCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //viewMain.backgroundColor = ColorConstant.grey_40
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
