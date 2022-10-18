//
//  ServiceProviderCell.swift
//  Finca
//
//  Created by harsh panchal on 26/08/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class ServiceProviderCell: UICollectionViewCell {

    @IBOutlet weak var heightImgView: NSLayoutConstraint!
    @IBOutlet weak var lblServiceProviderName: UILabel!
    @IBOutlet weak var imgServiceProvider: UIImageView!
    @IBOutlet var heightOfImage: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgServiceProvider.layer.cornerRadius = 10
        imgServiceProvider.layer.borderColor = #colorLiteral(red: 0.3960784314, green: 0.2235294118, blue: 0.4549019608, alpha: 1)
        imgServiceProvider.layer.borderWidth = 2
        // Initialization code
    }

}
