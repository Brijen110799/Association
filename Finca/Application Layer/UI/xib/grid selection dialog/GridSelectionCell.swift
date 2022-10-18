//
//  GridSelectionCell.swift
//  Finca
//
//  Created by harsh panchal on 11/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class GridSelectionCell: UICollectionViewCell {

    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var imgBrand: UIImageView!
    @IBOutlet weak var lblBrandName: UILabel!
    override var isSelected: Bool{
        didSet{
            imgCheck.isHidden = isSelected ? false : true
            imgBrand.layer.borderColor = isSelected ?  UIColor(named: "green 500")?.cgColor : UIColor(named: "ColorPrimary")?.cgColor 
            lblBrandName.textColor = isSelected ?  UIColor(named: "green 500") : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }


}
