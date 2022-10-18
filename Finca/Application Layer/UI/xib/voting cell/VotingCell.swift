//
//  VotingCell.swift
//  Finca
//
//  Created by harsh panchal on 28/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class VotingCell: UITableViewCell {

    @IBOutlet weak var mainVIew: UIView!
    @IBOutlet weak var lblNomineeName: UILabel!
    @IBOutlet weak var ImageRadio: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
      //  mainVIew.layer.cornerRadius = mainVIew.frame.height/2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        mainVIew.backgroundColor = selected ? UIColor(named: "ColorPrimary"): UIColor(named: "gray10")
        lblNomineeName.textColor  = selected ? UIColor.white : UIColor.black
    }
    
}
