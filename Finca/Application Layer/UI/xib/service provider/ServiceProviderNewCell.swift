//
//  ServiceProviderNewCell.swift
//  Finca
//
//  Created by Hardik on 7/14/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class ServiceProviderNewCell: UICollectionViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgServiceProvider: UIImageView!
    @IBOutlet weak var lblServiceProviderName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.viewMain.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
    
    }

}
