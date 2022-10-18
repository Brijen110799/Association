//
//  FincasysTeamCell.swift
//  Finca
//
//  Created by harsh panchal on 27/08/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class FincasysTeamCell: UICollectionViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgTeamImage: UIImageView!
    @IBOutlet weak var lblMemberName: UILabel!
    @IBOutlet weak var lblDesignation: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgTeamImage.layer.cornerRadius = imgTeamImage.frame.height/2
        imgTeamImage.layer.borderColor = #colorLiteral(red: 0.3960784314, green: 0.2235294118, blue: 0.4549019608, alpha: 1)
        imgTeamImage.layer.borderWidth = 2
    }

}
