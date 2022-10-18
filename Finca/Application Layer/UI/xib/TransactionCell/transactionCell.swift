//
//  transactionCell.swift
//  Finca
//
//  Created by Silverwing_macmini4 on 10/02/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit

class transactionCell: UITableViewCell {

    @IBOutlet weak var lbPaymentName: UILabel!
    @IBOutlet weak var lbTransactionDate: UILabel!
    
    @IBOutlet weak var constinvoiceheight: NSLayoutConstraint!
    @IBOutlet weak var lbTransactionAmount: UILabel!
    @IBOutlet weak var btninvo: UIButton!
    @IBOutlet weak var lbTransactionMode: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func btnInvoice(_ sender: Any) {
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
