//
//  SearchMemberCell.swift
//  Finca
//
//  Created by Silverwing Technologies on 26/05/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit

class SearchMemberCell: UITableViewCell {
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblMemberName: UILabel!
    @IBOutlet weak var lblMemberUnitNo: UILabel!
    var delegate : MemberListCellDelegate!
    var indexPath : IndexPath!
    @IBOutlet weak var ivGender: UIImageView!
    
    @IBOutlet weak var imgSmallIcon: UIImageView!
    @IBOutlet weak var lbDesg: UILabel!
    @IBOutlet weak var bCall: UIButton!
    @IBOutlet weak var viewCall: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
