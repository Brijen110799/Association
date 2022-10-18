//
//  RecievedMultimediaCell.swift
//  Finca
//
//  Created by Silverwing Technologies on 09/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class RecievedMultimediaCell: UITableViewCell {

    @IBOutlet weak var lbMessage: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var bReadMore: UIButton!
    var indexPath : IndexPath!
    var delegate : ChatClickDelegate!
    @IBOutlet weak var conWidthReadMore: NSLayoutConstraint!
    @IBOutlet weak var ivImage: UIImageView!
    
    @IBOutlet weak var viewMain: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // viewMain.roundCorners(corners: [.topLeft , .topRight , .bottomRight], radius: 10)

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
