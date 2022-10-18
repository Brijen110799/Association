//
//  FinCustomerListCell.swift
//  Finca
//
//  Created by Jay Patel on 30/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class FinCustomerListCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblNameInitials: UILabel!
    @IBOutlet var lblCustomerName: UILabel!
    @IBOutlet var lblType: UILabel!
    @IBOutlet var lblPhoneNumber: UILabel!
    @IBOutlet var imgLastData: UIImageView!
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet var imgCustomer: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      setThreeCorner(viewMain: viewMain)
    }
    func setThreeCorner(viewMain : UIView) {
        viewMain.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
    }
    
}
