//
//  MemberListCaht.swift
//  Finca
//
//  Created by anjali on 07/09/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
protocol MemberListCellDelgate {
    func doRemoveMemberfromGroup(indexPath:IndexPath)
}

class MemberListChat: UICollectionViewCell {

    @IBOutlet weak var ivUserProfile: UIImageView!
    @IBOutlet weak var viewChatCount: UIView!
    @IBOutlet weak var lbChatCount: UILabel!
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var viewCall: UIView!
    @IBOutlet weak var bCall: UIButton!
    @IBOutlet weak var lbUnitName: UILabel!
    @IBOutlet weak var imgCallChat: UIImageView!
    @IBOutlet weak var viewDeleteChatClicked: UIView!
    @IBOutlet weak var viewChatLbl: UIView!
    @IBOutlet weak var ivGender: UIImageView!
    
    @IBOutlet weak var viewCompanyName: UIView!
    @IBOutlet weak var lbCompanyName: MarqueeLabel!
    
    var delegate : MemberListCellDelgate!
    var indexPath : IndexPath!
    
    @IBOutlet weak var viewEmpty: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    @IBAction func btnRemoveUserClicked(_ sender: UIButton) {
        self.delegate.doRemoveMemberfromGroup(indexPath: self.indexPath)
    }
}
