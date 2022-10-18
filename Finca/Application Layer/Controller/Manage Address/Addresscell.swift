//
//  Addresscell.swift
//  Finca
//
//  Created by Nanshi Shivhare on 10/05/22.
//  Copyright © 2022 Silverwing. All rights reserved.
//

import UIKit

class Addresscell: UITableViewCell {

    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnshare: UIButton!
    @IBOutlet weak var btncall: UIButton!
    @IBOutlet weak var lblnumber: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lbltitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
