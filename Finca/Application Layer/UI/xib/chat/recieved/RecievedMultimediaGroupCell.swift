//
//  RecievedMultimediaGroupCell.swift
//  Finca
//
//  Created by Silverwing Technologies on 14/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class RecievedMultimediaGroupCell: UITableViewCell {
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lbMessage: UILabel!
    @IBOutlet weak var lbPersonName: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    
    var indexPath : IndexPath!
    var delegate : GroupChatDelegate!
    var delegateChat : ChatClickDelegate!
    @IBOutlet weak var conWidthReadMore: NSLayoutConstraint!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var bReadMore: UIButton!
      
    override func awakeFromNib() {
        super.awakeFromNib()
        viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMaxXMaxYCorner]
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
      @IBAction func btnOpenProfile(_ sender: UIButton) {
          self.delegate.doOpenMemberProfile(indexPath: indexPath)
      }
    
    @IBAction func onClickFullImage(_ sender: Any) {
           delegateChat.openReadMore(indexPath: indexPath, type: "fullImage")
       }
       @IBAction func onClickReadMore(_ sender: Any) {
           delegateChat.openReadMore(indexPath: indexPath, type: "readmore")
       }
    
}
