//
//  RenewYearTableCell.swift
//  Finca
//
//  Created by Fincasys Macmini on 27/04/22.
//  Copyright © 2022 Silverwing. All rights reserved.
//

import UIKit

class RenewYearTableCell: UITableViewCell {
    
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblAmount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
