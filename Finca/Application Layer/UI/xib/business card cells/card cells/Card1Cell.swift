//
//  Card1Cell.swift
//  Finca
//
//  Created by Hardik on 3/5/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class Card1Cell: UITableViewCell {
    var containsImage = false
    @IBOutlet weak var MainLogo:UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lbWebSite: UILabel!
    @IBOutlet weak var viewWebsite: UIView!
    
    @IBOutlet weak var viewMail: UIView!
    
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var viewCompanyName: UIView!
    @IBOutlet weak var constLeadingCompanyName : NSLayoutConstraint!
    @IBOutlet weak var constleadingWebsite : NSLayoutConstraint!
    @IBOutlet weak var ivWebsite: UIView!
    @IBOutlet weak var ivEmail : UIView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
