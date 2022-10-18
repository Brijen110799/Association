//
//  ElectionResultCell.swift
//  Finca
//
//  Created by harsh panchal on 14/08/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class ElectionResultCell: UITableViewCell {
@IBOutlet weak var viewProgress: UIView!    
    @IBOutlet weak var lblVotePercent: UILabel!
    @IBOutlet weak var lblNomineeName: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
