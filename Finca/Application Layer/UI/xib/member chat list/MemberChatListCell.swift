//
//  MemberChatListCell.swift
//  Finca
//
//  Created by anjali on 27/08/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class MemberChatListCell: UICollectionViewCell {

    @IBOutlet weak var lbChatCount: UILabel!
    @IBOutlet weak var viewChatCount: UIView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var ivImageProfile: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewChatCount.clipsToBounds = true
    }

}
