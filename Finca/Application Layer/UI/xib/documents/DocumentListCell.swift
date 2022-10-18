//
//  DocumentListCell.swift
//  Finca
//
//  Created by CHPL Group on 30/03/22.
//  Copyright © 2022 Silverwing. All rights reserved.
//

import UIKit

class DocumentListCell: UITableViewCell {
    @IBOutlet weak var heightbtndelete: NSLayoutConstraint!
    @IBOutlet weak var lbDocName: UILabel!
    @IBOutlet weak var lbDocumentTimeAndDate: UILabel!
    @IBOutlet weak var lbDocSubName: UILabel!
    @IBOutlet weak var btndelete: UIButton!
    @IBOutlet weak var ivDoc: UIImageView!
    @IBOutlet weak var heightlblDesc: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
