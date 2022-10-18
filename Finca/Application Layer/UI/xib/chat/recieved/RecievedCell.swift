//
//  RecievedCell.swift
//  Finca
//
//  Created by anjali on 13/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class RecievedCell: UITableViewCell {
    @IBOutlet weak var lbMessage: UILabel!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var bReadMore: UIButton!
    var indexPath : IndexPath!
    var delegate : ChatClickDelegate!
    @IBOutlet weak var conWidthReadMore:NSLayoutConstraint!
    @IBOutlet weak var viewMain: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        conWidthReadMore.constant = 5
        //viewMain.roundCorners(corners: [.topLeft , .topRight , .bottomRight], radius: 10)
        self.viewMain.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMinYCorner]
   
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClickReadMore(_ sender: Any) {
          delegate.openReadMore(indexPath: indexPath, type: "readmore")
      }
    
}
