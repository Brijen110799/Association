//
//  TeamMemberCell.swift
//  Finca
//
//  Created by Silverwing Technologies on 11/05/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit

class TeamMemberCell: UICollectionViewCell {

    @IBOutlet weak var lbDesg: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var ivProfile: UIImageView!
    
  
    @IBOutlet weak var bCall: UIButton!
    
    @IBOutlet weak var viewCall: UIView!
    
    @IBOutlet weak var bMsg: UIButton!
    @IBOutlet weak var viewMsg: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
