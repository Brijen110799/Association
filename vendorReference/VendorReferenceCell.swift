//
//  VendorReferenceCell.swift
//  Finca
//
//  Created by CHPL Group on 02/05/22.
//  Copyright © 2022 Silverwing. All rights reserved.
//

import UIKit

class VendorReferenceCell: UITableViewCell {
    @IBOutlet weak var lblTItle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCat: UILabel!
    @IBOutlet weak var lblMobno: UILabel!
    @IBOutlet weak var lblEmailid: UILabel!
    @IBOutlet weak var btnedit: UIButton!
    @IBOutlet weak var btndlt: UIButton!
    @IBOutlet weak var btnForEmail: UIButton!
    @IBOutlet weak var btnForCall: UIButton!
    
    @IBOutlet weak var heightEmailConst: NSLayoutConstraint!
    @IBOutlet weak var imgemail: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func btnDeleteCalled(_ sender: UIButton) {
       
    }
    @IBAction func btnedit(_ sender: UIButton) {
       
    }

}
