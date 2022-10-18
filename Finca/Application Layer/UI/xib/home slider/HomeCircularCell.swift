//
//  HomeCircularCell.swift
//  Finca
//
//  Created by Silverwing Technologies on 05/05/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit

class HomeCircularCell: UICollectionViewCell {
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var bDetails: UIButton!
   override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     //   viewCorner.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMinYCorner]
      //  viewCorner.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
    }

}
