//
//  VehicleCell.swift
//  Finca
//
//  Created by CHPL Group on 07/04/22.
//  Copyright © 2022 Silverwing. All rights reserved.
//

import UIKit

class VehicleCell: UITableViewCell {
   
    @IBOutlet weak var Topconstrainview: NSLayoutConstraint!
    @IBOutlet weak var lblvehiclestatus: UILabel!
    @IBOutlet weak var viewpending: UIView!
    @IBOutlet weak var lblVehicleNumber: UILabel!
    @IBOutlet weak var lbVehicleNameTitle: UILabel!
    @IBOutlet weak var lblVehicleName: UILabel!
    @IBOutlet weak var lbCompanyNameTitle: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lbMobileNumberTitle: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var ivVehicleType: UIImageView!
    @IBOutlet weak var ViewEditDlt: UIView!
    @IBOutlet weak var btnQrCode: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblnumberbottom: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
   // var indexPath : IndexPath!
    @IBOutlet weak var btnimgshow: UIButton!
    // var collectionView : UITableView!
    @IBOutlet weak var btncall: UIButton!
    //var delegate : UserProfileCellDelegates!
    @IBOutlet weak var heigthlblmobileval: NSLayoutConstraint!
    @IBOutlet weak var Heightlbmobile: NSLayoutConstraint!
    
    @IBOutlet weak var widthcompanyname: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
      
        // Initialization code
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnDeleteCalled(_ sender: UIButton) {
       // self.delegate.deleteButtonClicked(collectionView: self.collectionView, indexPath: self.indexPath)
    }
    @IBAction func btnQr(_ sender: UIButton) {
       // self.delegate.QrcodeButtonClicked(collectionView: self.collectionView, indexPath: self.indexPath)
    }
}
