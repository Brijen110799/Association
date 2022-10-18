//
//  VehicalParkingCell.swift
//  Finca
//
//  Created by Hardik on 7/29/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

protocol VisitorParkingCellButtonClicked{
    func onClickVisitorProfile(at indexPath : IndexPath!)
}

class VehicalParkingCell: UITableViewCell {

    
    var indexPath : IndexPath!
    var delegate : VisitorParkingCellButtonClicked!
    
    @IBOutlet weak var lblUnitName: UILabel!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblOwnerName: UILabel!
    @IBOutlet weak var lblDesignatedSlot: UILabel!
    @IBOutlet weak var lblVehicalNumber: UILabel!
    @IBOutlet weak var imgVehicalType: UIImageView!
    @IBOutlet weak var lblUserType: UILabel!
    @IBOutlet weak var lblAllocate: UILabel!
    @IBOutlet weak var lblDate:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func onClickProfile(_ sender: Any) {
         self.delegate.onClickVisitorProfile(at: indexPath)
    }
    
}
