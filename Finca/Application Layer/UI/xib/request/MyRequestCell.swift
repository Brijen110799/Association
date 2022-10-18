//
//  MyRequestCell.swift
//  Finca
//
//  Created by Hardik on 7/27/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import Cosmos
protocol RequestCellDelegate {
    func doGiveRating(indexpath: IndexPath)
}

class MyRequestCell: UITableViewCell {

    var indexPath : IndexPath!
    var delegate : RequestCellDelegate!
    @IBOutlet weak var lblDescription: MarqueeLabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var viewComplain: UIView!
    @IBOutlet var trailingOfLblDate: NSLayoutConstraint!
    @IBOutlet var mainViewOfRating: UIView!
    @IBOutlet var viewOfRating: CosmosView!
    @IBOutlet var btnOnRating: UIButton!
    @IBOutlet var viewAdminReply: UIView!
    @IBOutlet weak var viewComplainAdmin: UIView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var lblCmpStatus: UILabel!
    @IBOutlet weak var lblCmpTitle: MarqueeLabel!
    @IBOutlet weak var lblCmpDate: UILabel!
    @IBOutlet weak var lblCmpAdminMsg: UILabel!
    @IBOutlet var heightOflblAdmin: NSLayoutConstraint!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var lblCompainNo: UILabel!
    
    @IBOutlet weak var heightOflblCategory: NSLayoutConstraint!
    @IBOutlet var heightOflblAdminReply: NSLayoutConstraint!
    @IBOutlet var heightOfDashView: NSLayoutConstraint!
    
    @IBOutlet weak var lblStatusTitle: UILabel!
    @IBOutlet weak var lblDescriptionTitle: UILabel!
    @IBOutlet weak var lblRequestTitle: UILabel!
    @IBOutlet weak var lblAdminMsg: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bubbleView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
        lblCmpStatus.layer.cornerRadius = 5
        lblCmpStatus.layer.masksToBounds = true
        lblCompainNo.layer.cornerRadius = 5
        lblCompainNo.layer.masksToBounds = true
               
               self.viewComplainAdmin.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
        
        lblCmpTitle.type = .continuous
        lblCmpTitle.speed = .duration(15)
        lblCmpTitle.animationCurve = .easeInOut
        lblCmpTitle.fadeLength = 10.0
        
        lblDescription.type = .continuous
        lblDescription.speed = .duration(15)
        lblDescription.animationCurve = .easeInOut
        lblDescription.fadeLength = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnOfRating(_ sender: Any) {
        self.delegate.doGiveRating(indexpath: indexPath)
    }
    
}
