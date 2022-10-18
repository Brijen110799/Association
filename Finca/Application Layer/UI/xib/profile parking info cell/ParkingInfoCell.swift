//
//  ParkingInfoCell.swift
//  Finca
//
//  Created by silverwing_macmini3 on 12/13/1398 AP.
//  Copyright © 1398 anjali. All rights reserved.
//

import UIKit

class ParkingInfoCell: UITableViewCell {

    @IBOutlet weak var imgVehicalType: UIImageView!
    @IBOutlet weak var lblVehicalNumber: UILabel!
    @IBOutlet weak var lblParkingLocation: MarqueeLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
