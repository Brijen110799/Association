//
//  MyEventCell.swift
//  Finca
//
//  Created by Hardik on 3/31/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
protocol doActionMyEvent {
    func doViewPass(indexpath : IndexPath)
    func doCancel(indexpath : IndexPath)
    func doReceipt(indexpath : IndexPath)
}

class MyEventCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
  
    @IBOutlet weak var ivEvent: UIImageView!
    @IBOutlet weak var lblMonthYear: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblNoAdult: UILabel!
    @IBOutlet weak var lblNoChild: UILabel!
    @IBOutlet weak var lblBookedGuests: UILabel!
    @IBOutlet weak var viewGuestPass: UIView!
    @IBOutlet weak var viewChildPass: UIView!
    @IBOutlet weak var viewAdultPass: UIView!
    @IBOutlet weak var viewOfReceipt: UIView!
    @IBOutlet weak var viewOfCancelPasses: UIView!
    @IBOutlet weak var lblEventType: UILabel!
    
    @IBOutlet weak var lbAdult: UILabel!
    @IBOutlet weak var lbChild: UILabel!
    @IBOutlet weak var lbGuest: UILabel!
    @IBOutlet weak var bPass: UIButton!
    @IBOutlet weak var bCancel: UIButton!
    @IBOutlet weak var bViewRecipt: UIButton!
    var data : doActionMyEvent!
    var indexpath : IndexPath!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ivEvent.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClickCancelPasses(_ sender: Any) {
        self.data.doCancel(indexpath: indexpath.self)
    }
    @IBAction func onClickViewReceipt(_ sender: Any) {
        self.data.doReceipt(indexpath: indexpath.self)
    }
    @IBAction func onClickViewPass(_ sender: Any) {
        self.data.doViewPass(indexpath: indexpath.self)
    }
}
