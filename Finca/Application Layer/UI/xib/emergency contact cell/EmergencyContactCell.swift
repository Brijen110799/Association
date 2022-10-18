//
//  EmergencyContactCell.swift
//  Finca
//
//  Created by harsh panchal on 06/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
protocol EmergencyButtonActions {
    func CallContact(at indexPath:IndexPath!)
    func onClickDelete(at indexPath:IndexPath!)
    
}
class EmergencyContactCell: UITableViewCell {
    var actions:EmergencyButtonActions!
    var indexPath:IndexPath!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblPersonName: UILabel!
    @IBOutlet weak var lblOccupation: UILabel!
//    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblThumbnail: UILabel!


    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var viewCall: UIView!
    @IBOutlet weak var bDelete: UIButton!
    @IBOutlet weak var viewDelete: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewMain.makeBubbleView()
    }

    @IBAction func btnCallClicked(_ sender: UIButton) {
        self.actions.CallContact(at: self.indexPath)
    }

    @IBAction func onClickDelete(_ sender: UIButton) {
        self.actions.onClickDelete(at: self.indexPath)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
