//
//  BuildingDetailsCell.swift
//  Finca
//
//  Created by harsh panchal on 28/08/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class BuildingDetailsCell: UITableViewCell {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgSaveFile: UIImageView!
    @IBOutlet weak var btnMobile: UIButton!
    @IBOutlet weak var btnEmail: UIButton!
  
    @IBOutlet weak var btnSaveContact: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRole: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    //@IBOutlet weak var BtnMobile: UIButton!
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var lbMobile: UILabel!
    @IBOutlet weak var lbRole: UILabel!
   
    @IBOutlet weak var viewCall: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

