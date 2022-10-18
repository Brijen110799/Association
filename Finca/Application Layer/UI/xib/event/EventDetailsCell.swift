//
//  EventDetailsCell.swift
//  Finca
//
//  Created by Hardik on 3/28/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
protocol EventBookDelegate {
    func doEventBook(indexpath : IndexPath)
}

class EventDetailsCell: UITableViewCell {
    var data : EventBookDelegate!
    var indexPath : IndexPath!

    @IBOutlet weak var btnEventAddress: UIButton!
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var lblAttendents: UILabel!
    @IBOutlet weak var lblAdultFees: UILabel!
    @IBOutlet weak var lblChildFees: UILabel!
    @IBOutlet weak var lblGuestFees: UILabel!
    @IBOutlet weak var viewBookEvent: UIView!
    @IBOutlet weak var heightofViewBookEvent: NSLayoutConstraint!
    @IBOutlet weak var lblEventDate: UILabel!
    @IBOutlet weak var lbllocation: UILabel!
    @IBOutlet weak var viewAdult: UIView!
    @IBOutlet weak var viewChild: UIView!
    @IBOutlet weak var viewGuest: UIView!
    
    @IBOutlet weak var lbAdult: UILabel!
    @IBOutlet weak var lbChild: UILabel!
    @IBOutlet weak var lbGuest: UILabel!
    @IBOutlet weak var lbBookevent: UILabel!
    @IBOutlet weak var bBookEvent: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func onClickBookEvent(_ sender: Any) {
        self.data.doEventBook(indexpath: self.indexPath)
    }
}
