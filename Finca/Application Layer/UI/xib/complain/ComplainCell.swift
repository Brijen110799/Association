//
//  ComplainCell.swift
//  Finca
//
//  Created by harsh panchal on 02/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import Cosmos
protocol ComplainCellDelegate {
    func doGiveRating(indexpath: IndexPath)
}
class ComplainCell: UITableViewCell {
    
    @IBOutlet weak var lblCategory: UILabel!
    var indexPath : IndexPath!
    var delegate : ComplainCellDelegate!
    @IBOutlet weak var constraintViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewBtnEdit: UIView!
    @IBOutlet weak var viewBtnDelete: UIView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var btnGiveFeedback: UIButton!
    @IBOutlet weak var viewGiveFeedback: UIView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewEdit: UIView!
    @IBOutlet weak var conWidth: NSLayoutConstraint!
    @IBOutlet weak var viewDelete: UIView!
    
    @IBOutlet weak var viewComplain: UIView!
    @IBOutlet var trailingOfLblDate: NSLayoutConstraint!
    @IBOutlet var mainViewOfRating: UIView!
    @IBOutlet var viewOfRating: CosmosView!
    @IBOutlet var btnOnRating: UIButton!
    @IBOutlet var viewAdminReply: UIView!
    @IBOutlet var constaintHieghtAdminMessage: NSLayoutConstraint!
    @IBOutlet weak var viewComplainAdmin: UIView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var lblCmpStatus: UILabel!
    @IBOutlet weak var lblCmpTitle: MarqueeLabel!
    @IBOutlet weak var lblCmpDesc: UILabel!
    @IBOutlet weak var lblCmpDate: UILabel!
    @IBOutlet weak var lblCmpAdminMsg: UILabel!
    @IBOutlet var heightOflblAdmin: NSLayoutConstraint!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var lblCompainNo: UILabel!
    
    @IBOutlet weak var heightOflblCategory: NSLayoutConstraint!
    @IBOutlet var heightOflblAdminReply: NSLayoutConstraint!
    @IBOutlet var heightOfDashView: NSLayoutConstraint!
    
    @IBOutlet weak var bTapDesc: UIButton!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var lblStatusTitle: UILabel!
    @IBOutlet weak var lblCategoryTitle: UILabel!
    @IBOutlet weak var lblComplainTitle: UILabel!
    @IBOutlet weak var lblDescriptionTitle: UILabel!
    
    @IBOutlet weak var lblAdminMsg: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bubbleView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
        lblCmpStatus.layer.cornerRadius = 5
        lblCmpStatus.layer.masksToBounds = true
      lblCompainNo.layer.cornerRadius = 5
        lblCompainNo.layer.masksToBounds = true
        
        self.viewComplainAdmin.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
        //        viewMain.layer.shadowRadius = 3
        //        viewMain.layer.shadowOffset = CGSize.zero
        //        viewMain.layer.shadowOpacity = 0.3
        //        viewMain.layer.cornerRadius = 5
        
        lblCmpTitle.type = .continuous
        lblCmpTitle.speed = .duration(15)
        lblCmpTitle.animationCurve = .easeInOut
        lblCmpTitle.fadeLength = 10.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func btnOfRating(_ sender: Any) {
        self.delegate.doGiveRating(indexpath: indexPath)
    }
    
    
}
