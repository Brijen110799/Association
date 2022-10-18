//
//  EventCell.swift
//  Finca
//
//  Created by anjali on 03/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class EventCell: UICollectionViewCell {

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
        // Initialization code
        viewMain.layer.borderColor = UIColor.clear.cgColor
        viewMain.layer.borderWidth = 0.5

        viewMain.layer.cornerRadius = 4
        viewMain.clipsToBounds = true
        ivImageEvent.contentMode = .scaleAspectFill
    }

}
