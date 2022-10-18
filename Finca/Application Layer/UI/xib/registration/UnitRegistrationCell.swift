//
//  UnitRegistrationCell.swift
//  Finca
//
//  Created by anjali on 31/08/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class UnitRegistrationCell: UICollectionViewCell {
    @IBOutlet weak var lbTitle: MarqueeLabel!
    @IBOutlet weak var viewMain: UIView!
    var gradient : CAGradientLayer!
    
    @IBOutlet weak var viewAvailabel: RadialGradientSqureView!
    @IBOutlet weak var viewNotAvailabel: RadialGradientSqureView!
    @IBOutlet weak var viewForPrimary: RadialGradientSqureView!
    @IBOutlet weak var ViewPending : RadialGradientSqureView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewAvailabel.isHidden = true
        viewNotAvailabel.isHidden = true
    }
    
    func setViewAvilabe(status : String,isAddMoreUnit:Bool) {
        
    if !isAddMoreUnit {

        if status == "0" {
            viewAvailabel.isHidden = false
            viewNotAvailabel.isHidden = true
            viewForPrimary.isHidden = true

            } else if status == "4"
            {
                viewAvailabel.isHidden = false
                viewNotAvailabel.isHidden = true
                viewForPrimary.isHidden = true
            }
        else {
            viewAvailabel.isHidden = true
            viewNotAvailabel.isHidden = false
            viewForPrimary.isHidden = true

            }

    }else {

        if status == "0" {
            viewAvailabel.isHidden = false
            viewNotAvailabel.isHidden = true
            viewForPrimary.isHidden = true

        } else if status == "1"{
            viewAvailabel.isHidden = true
            viewNotAvailabel.isHidden = true
            viewForPrimary.isHidden = false

       }
        else if status == "4"
        {
            viewAvailabel.isHidden = true
            viewNotAvailabel.isHidden = true
            viewForPrimary.isHidden = false
        }
        else{
            viewAvailabel.isHidden = true
            viewNotAvailabel.isHidden = false
            viewForPrimary.isHidden = true
        }
    }
}
    func addGradient(viewMain:UIView!,color:[CGColor]){
        gradient = CAGradientLayer()
        gradient.frame = viewMain.frame
        gradient.colors = color
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
//        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        viewMain.layer.insertSublayer(gradient, at: 0)
    }
}
