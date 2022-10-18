//
//  PenaltyCell.swift
//  Finca
//
//  Created by harsh panchal on 27/12/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
protocol PenaltyCellDelegate {
    //func doCallPay(indexPath : IndexPath!)
    func showcaseImage(indexPath : IndexPath!)
    func showPaymentDetail(indexPath : IndexPath!)
}
class PenaltyCell: UITableViewCell {
    var delegate : PenaltyCellDelegate!
    var indexPath : IndexPath!
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewButtonPay: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPaymentStatus: UILabel!
    @IBOutlet weak var imgPenaltyImage: UIImageView!
    @IBOutlet weak var lblPenaltyDescription: UILabel!
    @IBOutlet weak var bPay: UIButton!
    @IBOutlet weak var bImage : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewMain.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
   
}
