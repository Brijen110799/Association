//
//  SocietyRegistrationTableCell.swift
//  Finca
//
//  Created by Silverwing Technologies on 01/07/21.
//  Copyright © 2021 Silverwing. All rights reserved.
//

import UIKit

class SocietyRegistrationTableCell: UITableViewCell {
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
