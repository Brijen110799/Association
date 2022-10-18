//
//  FamilyMemberRelationCell.swift
//  Finca
//
//  Created by Silverwing Technologies on 22/12/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class FamilyMemberRelationCell: UITableViewCell {

    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var lbRelation: UILabel!
    @IBOutlet weak var lbName: UILabel!
    
    @IBOutlet weak var bRelation: UIButton!
    
    @IBOutlet weak var viewHidden: UIView!
    
    
    @IBOutlet weak var tfOtherRelation: ACFloatingTextfield!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
