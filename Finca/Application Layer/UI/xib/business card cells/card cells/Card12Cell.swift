//
//  Card12Cell.swift
//  Finca
//
//  Created by Hardik on 3/6/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class Card12Cell: UITableViewCell {
    var containsImage = false
    @IBOutlet weak var MainLogo:UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var viewWebsite: UIView!
    @IBOutlet weak var lbWebSite: UILabel!
    @IBOutlet weak var viewEmail : UIView!
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
