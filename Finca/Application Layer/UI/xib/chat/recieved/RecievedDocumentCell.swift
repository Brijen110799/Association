//
//  RecievedDocumentCell.swift
//  Finca
//
//  Created by Silverwing Technologies on 16/05/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class RecievedDocumentCell: UITableViewCell {
    @IBOutlet weak var ivDocType: UIImageView!
    @IBOutlet weak var lbDocName: UILabel!
    @IBOutlet weak var lbDocSize: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var bDownload: UIButton!
    @IBOutlet weak var viewMain: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
