//
//  RecievedLocationCell.swift
//  Finca
//
//  Created by Silverwing Technologies on 18/05/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class RecievedLocationCell: UITableViewCell {

    @IBOutlet weak var ivImageLocation: UIImageView!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var viewMain: UIView!
     @IBOutlet weak var bLocation: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
