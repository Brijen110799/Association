//
//  WalletTranctionCell.swift
//  Finca
//
//  Created by Silverwing Technologies on 22/11/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class WalletTranctionCell: UITableViewCell {

    @IBOutlet weak var ivArrow: UIImageView!
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbAmountCreadit: UILabel!
    @IBOutlet weak var lbAmountBal: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
