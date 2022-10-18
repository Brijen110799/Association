//
//  FinBookReportCell.swift
//  Finca
//
//  Created by harsh panchal on 24/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class FinBookReportCell: UITableViewCell {

    @IBOutlet weak var lblCredit: UILabel!
    @IBOutlet weak var lblDebit: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
