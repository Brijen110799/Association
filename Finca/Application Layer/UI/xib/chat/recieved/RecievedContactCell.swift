//
//  RecievedContactCell.swift
//  Finca
//
//  Created by Silverwing Technologies on 15/05/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class RecievedContactCell: UITableViewCell {

    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbNumber: UITextView!
    @IBOutlet weak var bAddContact: UIButton!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var viewMain: UIView!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     //   viewMain.roundCorners(corners: [.topLeft , .topRight , .bottomRight], radius: 10)
        lbNumber.contentInset = UIEdgeInsets(top: -7.0,left: 0.0,bottom: 0,right: 0.0)
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
