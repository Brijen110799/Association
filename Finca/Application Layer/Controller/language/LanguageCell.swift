//
//  LanguageCell.swift
//  Finca
//
//  Created by Silverwing Technologies on 15/03/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit

class LanguageCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var lbPrimaryLanguage: UILabel!
    
    @IBOutlet weak var lbSecondryLanguage: UILabel!
    
    @IBOutlet weak var ivLanguage: UIImageView!
    @IBOutlet weak var ivCheck: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
//        if selected {
//            print("selected")
//            mainView.layer.borderColor = ColorConstant.green500.cgColor
//            ivCheck.isHidden = false
//        } else {
//            print("un selected")
//            ivCheck.isHidden = true
//            mainView.layer.borderColor = ColorConstant.grey_10.cgColor
//        }
    }
        
     
   
    
}
