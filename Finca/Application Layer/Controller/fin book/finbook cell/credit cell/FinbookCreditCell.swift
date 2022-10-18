//
//  FinbookCreditCell.swift
//  Finca
//
//  Created by harsh panchal on 17/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class FinbookCreditCell: UITableViewCell {
    @IBOutlet weak var viewEntryData: UIView!
    @IBOutlet weak var viewDeletedEntry: UIView!
    @IBOutlet weak var CellWidth: NSLayoutConstraint!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblRemark: UILabel!
    @IBOutlet weak var lblFinalAmount: UILabel!
    
    @IBOutlet weak var viewCredit: UIView!
    
    @IBOutlet weak var lbDeletePayment: UILabel!
    @IBOutlet weak var viewRemark: UIView!
    
    @IBOutlet weak var viewTime: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        CellWidth.constant = UIScreen.main.bounds.width - 100
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setThreeCorner(viewMain: viewCredit)
        
    }
    func setThreeCorner(viewMain : UIView) {
        viewMain.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
    }
}
