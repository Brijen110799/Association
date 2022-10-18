//
//  EventTVCell.swift
//  Finca
//
//  Created by Hardik on 3/27/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class EventTVCell: UITableViewCell {
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet var lblEventType: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var lbAttending: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lbDay: UILabel!
    @IBOutlet weak var lbMonth: UILabel!
    @IBOutlet weak var lbYear: UILabel!
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var ivImageEvent: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async {
       
        self.viewMain.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
        self.viewMain.cornerRadius = 10
        }
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
