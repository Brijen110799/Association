//
//  ReceivedContactGroupCell.swift
//  Finca
//
//  Created by harsh panchal on 25/05/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class ReceivedContactGroupCell: UITableViewCell {

    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbNumber: UITextView!
    @IBOutlet weak var bAddContact: UIButton!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblSenderName: UILabel!
    var cellDelegate : GroupChatDelegate!
    var indexPath : IndexPath!

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
        self.cellDelegate.doOpenMemberProfile(indexPath: self.indexPath)
    }

}
