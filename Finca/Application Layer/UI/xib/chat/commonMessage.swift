//
//  commonMessage.swift
//  Finca
//
//  Created by harsh panchal on 28/01/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class commonMessage: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var layoutwdth: NSLayoutConstraint!
    @IBOutlet weak var lblMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewMain.layer.backgroundColor = UIColor.clear.cgColor
        layoutwdth.constant = UIScreen.main.bounds.width - 150
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

