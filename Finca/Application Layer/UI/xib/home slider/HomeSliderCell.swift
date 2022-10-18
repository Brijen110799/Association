//
//  HomeSliderCell.swift
//  O Shreeji dental clinic
//
//  Created by anjali on 18/04/19.
//  Copyright © 2019 Silverwing Technologies Pvt Ltd. All rights reserved.
//

import UIKit

class HomeSliderCell: UIView  {

    
    @IBOutlet weak var lbDescription: MarqueeLabel!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var btnClickPager: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ivImage.contentMode = .scaleToFill
        lbDescription.type = .continuous
        lbDescription.animationCurve = .easeIn
        lbDescription.fadeLength = 12
        //self.setupMarqee(label: viewCard.lbDescription)
        lbDescription.speed = .duration(18.0)
       
    }

}
