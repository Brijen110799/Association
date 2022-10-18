//
//  BankDetailsItem.swift
//  Finca
//
//  Created by Silverwing Technologies on 31/05/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit

class BankDetailsItem: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lbBankName: UILabel!
    @IBOutlet weak var lbAccountName: UILabel!
    @IBOutlet weak var lbAccountNumber: UILabel!
    @IBOutlet weak var bShare: UIButton!
    @IBOutlet weak var bEdit: UIButton!
    @IBOutlet weak var bDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
