//
//  UnitUsageOverviewDialog.swift
//  Finca
//
//  Created by harsh panchal on 19/05/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class UnitUsageOverviewDialog: BaseVC {
    @IBOutlet weak var lblCurrentReading: UILabel!
    @IBOutlet weak var lblPreviousReading: UILabel!
    @IBOutlet weak var lblUnitCount: UILabel!
    @IBOutlet weak var lblUnitPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var bCancel: UIButton!
    
    @IBOutlet weak var lbPending: UILabel!
    @IBOutlet weak var lbCurrentReading: UILabel!
    @IBOutlet weak var lbPreviousReading: UILabel!
    @IBOutlet weak var lbUnitCount: UILabel!
    @IBOutlet weak var lbUnitPrice: UILabel!
   
    var context : BillFragmentVC!
    var billDetail : Bill_Model!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblDate.text = billDetail.billName
        self.lblCurrentReading.text = billDetail.currentUnitRead
        self.lblPreviousReading.text = billDetail.previousUnit
        self.lblUnitCount.text = String(Double(billDetail.currentUnitRead!)! - Double(billDetail.previousUnit!)!)
        self.lblUnitPrice.text = billDetail.unitPrice
        
        lbCurrentReading.text = doGetValueLanguage(forKey: "current_reading")
        lbPreviousReading.text = doGetValueLanguage(forKey: "previous_reading")
        lbUnitPrice.text = doGetValueLanguage(forKey: "price_nper_unit")
        lbUnitCount.text = doGetValueLanguage(forKey: "units")
        
        lbPending.text = doGetValueLanguage(forKey: "pending")
        bCancel.setTitle(doGetValueLanguage(forKey: "close"), for: .normal)
        
    }
    
    @IBAction func btnAddClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func btnCancelClicked(_ sender: UIButton) {
    }
}
