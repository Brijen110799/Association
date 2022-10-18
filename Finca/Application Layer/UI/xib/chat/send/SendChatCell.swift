//
//  SendChatCell.swift
//  Finca
//
//  Created by anjali on 13/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
protocol ChatClickDelegate {
    func openReadMore(indexPath : IndexPath, type : String)
    
}
class SendChatCell: UITableViewCell {
   
   
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var lbMessage: UILabel!
    @IBOutlet var imgTick: UIImageView!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lbTime: UILabel!
    
    @IBOutlet weak var bReadMore: UIButton!
    var indexPath : IndexPath!
    var delegate : ChatClickDelegate!
    
    @IBOutlet weak var viewDelete: UIView!
    @IBOutlet weak var conWidthReadMore: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        conWidthReadMore.constant = 5
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
