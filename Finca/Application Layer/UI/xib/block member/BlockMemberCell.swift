//
//  BlockMemberCell.swift
//  Finca
//
//  Created by anjali on 12/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class BlockMemberCell: UICollectionViewCell {
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lbTitle: MarqueeLabel!
    @IBOutlet weak var viewUnselect: RadialGradientView!
    @IBOutlet weak var viewTest: UIView!
    @IBOutlet weak var lbFullNeme: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
      
//        DispatchQueue.main.async {
//
//            self.lbTitle.type = .continuous
//            self.lbTitle.speed = .duration(15)
//            self.lbTitle.animationCurve = .easeInOut
//            self.lbTitle.fadeLength = 10.0
//            self.lbTitle.restartLabel()
//        }
        
    }
}
