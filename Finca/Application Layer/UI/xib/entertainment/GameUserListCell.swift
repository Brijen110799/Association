//
//  GameUserListCell.swift
//  Finca
//
//  Created by Silverwing Technologies on 01/05/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class GameUserListCell: UITableViewCell {

    @IBOutlet weak var lbPlayerName: UILabel!
    @IBOutlet weak var lbPoint: UILabel!
    @IBOutlet weak var ivProfile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
