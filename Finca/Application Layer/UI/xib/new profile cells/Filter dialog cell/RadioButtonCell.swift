//
//  RadioButtonCell.swift
//  Finca
//
//  Created by harsh panchal on 19/02/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class RadioButtonCell: UITableViewCell {

    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var imgRadioButton: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        imgRadioButton.image = selected ? UIImage(named: "radio-selected") : UIImage(named: "radio-blank")
        imgRadioButton.tintColor = UIColor(named: "ColorPrimary")
        imgRadioButton.image = imgRadioButton.image?.withRenderingMode(.alwaysTemplate)
    }
    
}
