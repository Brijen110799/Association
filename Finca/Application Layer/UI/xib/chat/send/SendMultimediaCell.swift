//
//  SendMultimediaCell.swift
//  Finca
//
//  Created by Silverwing Technologies on 09/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class SendMultimediaCell: UITableViewCell {

    @IBOutlet weak var lbMessage: UILabel!
    @IBOutlet var imgTick: UIImageView!
    
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var bReadMore: UIButton!
    var indexPath : IndexPath!
    var delegate : ChatClickDelegate!
    @IBOutlet weak var conWidthReadMore: NSLayoutConstraint!
    @IBOutlet weak var ivImage: UIImageView!

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewDelete: UIView!
    @IBOutlet weak var bFullImage: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewMain.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMinYCorner]
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClickFullImage(_ sender: Any) {
          delegate.openReadMore(indexPath: indexPath, type: "fullImage")
      }
      @IBAction func onClickReadMore(_ sender: Any) {
          delegate.openReadMore(indexPath: indexPath, type: "readmore")
      }
}
