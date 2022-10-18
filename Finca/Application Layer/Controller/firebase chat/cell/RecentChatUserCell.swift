//
//  RecentChatUserCell.swift
//  Finca
//
//  Created by Silverwing Technologies on 29/12/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class RecentChatUserCell: UITableViewCell {
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var lbUnitName: UILabel!
    @IBOutlet weak var lbMsg: UILabel!
    @IBOutlet weak var lbCount: UILabel!
    @IBOutlet weak var viewCount: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
