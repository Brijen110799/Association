//
//  ClassifiedCell.swift
//  Finca
//
//  Created by Jay Patel on 19/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

protocol ActionClassified {
    func doEdit(indexpath : IndexPath)
}

class ClassifiedCell: UITableViewCell {
   
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewEdit: UIView!
    @IBOutlet var imgClassified: UIImageView!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblManufacturingYear: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblBrand: UILabel!
    @IBOutlet var lblFeatures: UILabel!
    @IBOutlet var ViewDelete: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgDelete: UIImageView!
    @IBOutlet var viewImgClassified: UIView!
    
    @IBOutlet var lbLocation: UILabel!
    @IBOutlet var lbBrand: UILabel!
    @IBOutlet var lbPrice: UILabel!
    @IBOutlet var lbManufacturingYear: UILabel!
    @IBOutlet var lbLocationLabel: UILabel!
    @IBOutlet var lbDate: UILabel!

    @IBOutlet var lbCategory: UILabel!
    @IBOutlet var lbCategoryLabel: UILabel!
    
    var data : ActionClassified!
    var indexpath : IndexPath!
    
    @IBOutlet weak var viewBottom: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
       self.viewMain.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func btnDelete(_ sender: Any) {
      
    }
    @IBAction func onClickEdit(_ sender: Any) {
        self.data.doEdit(indexpath: indexpath)
    }
    
}
