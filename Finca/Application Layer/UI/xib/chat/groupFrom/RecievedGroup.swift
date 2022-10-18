//
//  RecievedGroup.swift
//  Finca
//
//  Created by anjali on 08/09/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
protocol GroupChatDelegate {
    func doOpenMemberProfile(indexPath : IndexPath)
}
class RecievedGroup: UITableViewCell {
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lbMessage: UILabel!
    @IBOutlet weak var lbPersonName: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    var indexPath : IndexPath!
    var delegate : GroupChatDelegate!
    @IBOutlet weak var bReadMore: UIButton!
    @IBOutlet weak var conWidthReadMore: NSLayoutConstraint!
    var delegateChat : ChatClickDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMaxXMaxYCorner]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnOpenProfile(_ sender: UIButton) {
        self.delegate.doOpenMemberProfile(indexPath: indexPath)
    }
    @IBAction func onClickReadMore(_ sender: Any) {
        delegateChat.openReadMore(indexPath: indexPath, type: "readmore")
    }
}
