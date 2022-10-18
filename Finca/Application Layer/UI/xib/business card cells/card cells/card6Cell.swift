//
//  card6Cell.swift
//  Finca
//
//  Created by Hardik on 3/6/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class card6Cell: UITableViewCell {
    @IBOutlet weak var lblUserName: UILabel!
       var containsImage = false
    @IBOutlet weak var MainLogo:UIImageView!
       @IBOutlet weak var lblJobTitle: UILabel!
       @IBOutlet weak var lblAddress: UILabel!
       @IBOutlet weak var lblPhone: UILabel!
       @IBOutlet weak var lblEmail: UILabel!
       @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lbWebSite: UILabel!
    @IBOutlet weak var viewWebsite: UIView!
    
    @IBOutlet weak var imgEmail : UIImageView!
    @IBOutlet weak var imgwebsite : UIImageView!
    @IBOutlet weak var imglocation : UIImageView!
    @IBOutlet weak var imgAddress : UIImageView!
    @IBOutlet weak var viewMail: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
