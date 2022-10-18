//
//  UserActivityCell.swift
//  Finca
//
//  Created by harsh panchal on 08/05/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class UserActivityCell: UITableViewCell {
    enum ViewType {
        case right
        case left
    }
    ///view for the user side activities
    @IBOutlet weak var viewRightCorner: UIView!
    @IBOutlet weak var viewContainerRight: UIView!
    ///view for the admin side activities
    @IBOutlet weak var viewLeftCorner: UIView!
    @IBOutlet weak var viewContainerLeft: UIView!
    ///this view should remain visible everytime
    @IBOutlet weak var viewFillerSpace: UIView!
    @IBOutlet weak var viewStackView: UIStackView!
    @IBOutlet weak var lblTimeStamp: UILabel!
    @IBOutlet weak var lblActivityDescription: UILabel!
    @IBOutlet weak var lblRightTimeStamp: UILabel!
    @IBOutlet weak var lblRightActivityDescription: UILabel!
    @IBOutlet weak var imgRightActivityType: UIImageView!
    @IBOutlet weak var imgActivityType: UIImageView!
    
    var viewType : ViewType!{
        didSet{
            self.viewStackView.setNeedsLayout()
            switch viewType {
            case .left:
                self.viewLeftCorner.isHidden = false
                self.viewRightCorner.isHidden = true
                break
            case .right:
                self.viewLeftCorner.isHidden = true
                self.viewRightCorner.isHidden = false
                break
            default:
                break
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContainerLeft.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner]
        viewContainerRight.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner]
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
