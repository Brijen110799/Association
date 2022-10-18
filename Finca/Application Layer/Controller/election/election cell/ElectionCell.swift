//
//  ElectionCell.swift
//  Finca
//
//  Created by harsh panchal on 11/08/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class ElectionCell: UITableViewCell {
    @IBOutlet weak var lblElectionTitle: UILabel!
    @IBOutlet weak var lblElectionAddedBy: UILabel!
    @IBOutlet weak var lblElectionStartDate: UILabel!

    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var viewCreator: UIView!
    @IBOutlet weak var viewEndDate: UIView!
    
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var lblElectionStatus: UILabel!

    @IBOutlet weak var lblStartDate: UILabel!
    
    @IBOutlet weak var lbBy: UILabel!
     @IBOutlet weak var lbStartDate: UILabel!
    @IBOutlet weak var lblElectionEndDate: UILabel!
    @IBOutlet weak var bubbleVierw: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        bubbleVierw.makeBubbleView()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension UIView{
    func makeBubbleView(){
        self.layer.maskedCorners = [.layerMinXMinYCorner , .layerMinXMaxYCorner,.layerMaxXMinYCorner]
    }
}
