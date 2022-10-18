//
//  ReceivedDocumentGroupCell.swift
//  Finca
//
//  Created by harsh panchal on 25/05/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit


class ReceivedDocumentGroupCell: UITableViewCell {
    @IBOutlet weak var lblSenderName: UILabel!
    @IBOutlet weak var ivDocType: UIImageView!
    @IBOutlet weak var lbDocName: UILabel!
    @IBOutlet weak var lbDocSize: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var bDownload: UIButton!
    @IBOutlet weak var viewMain: UIView!
    var delegate : GroupChatDelegate!
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
    
    @IBAction func btnOpenSenderProfile(_ sender: UIButton) {
        self.delegate.doOpenMemberProfile(indexPath: self.indexPath)
    }
}
