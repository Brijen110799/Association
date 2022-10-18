//
//  MemberListCell.swift
//  Finca
//
//  Created by harsh panchal on 09/01/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
protocol MemberListCellDelegate {
    func didSelectMember (at indexPath : IndexPath!,selectedStatus : Bool!)
}
class MemberListCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblMemberName: UILabel!
    @IBOutlet weak var lblMemberUnitNo: UILabel!
    var delegate : MemberListCellDelegate!
    var indexPath : IndexPath!
    @IBOutlet weak var ivGender: UIImageView!
    
    @IBOutlet weak var lbDesg: UILabel!
    @IBOutlet weak var bCall: UIButton!
    @IBOutlet weak var viewCall: UIView!
    @IBOutlet weak var viewCompanyName: UIView!
    @IBOutlet weak var lbCompanyName: UILabel!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
       
            super.setSelected(selected, animated: animated)
//            if delegate != nil{
//                self.delegate.didSelectMember(at: indexPath, selectedStatus: selected ? true : false)
//            }
//            lblMemberName.textColor = selected ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//            lblMemberUnitNo.textColor = selected ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : ColorConstant.primaryColor
//            mainView.backgroundColor = selected ? ColorConstant.grey_40:#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//       self.delegate.didSelectMember(at: self.indexPath, selectedStatus: true) : self.delegate.didSelectMember(at: self.indexPath, selectedStatus: false)
        
    }
}
