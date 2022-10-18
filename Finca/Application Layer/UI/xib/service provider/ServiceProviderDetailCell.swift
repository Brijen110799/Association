//
//  ServiceProviderDetailCell.swift
//  Finca
//
//  Created by harsh panchal on 26/08/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
protocol ServiceProviderDelegate {
    func checkboxToggleButton(indexPath : IndexPath!)
}
class ServiceProviderDetailCell: UITableViewCell {

    @IBOutlet weak var imgMail: UIImageView!
    @IBOutlet weak var imgCall: UIImageView!
    @IBOutlet weak var imgServieProvider: UIImageView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblName: MarqueeLabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgIsVerified: UIImageView!
    
    @IBOutlet weak var ivVerified: UIImageView!
    @IBOutlet var btnIsCheck: UIButton!
    var indexPath : IndexPath!
    var delegate : ServiceProviderDelegate!
    
    @IBOutlet weak var bViewProfile: UIButton!
    @IBOutlet weak var bCall: UIButton!
    @IBOutlet weak var bLocation: UIButton!
    @IBOutlet weak var bEmail: UIButton!
  
     @IBOutlet weak var viewMail: UIView!
    
    @IBOutlet weak var lblDistance: UILabel!
    
    @IBOutlet weak var lbCategory: UILabel!
    
    @IBOutlet weak var bottomContraintView: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
    
        imgMail.tintColor = ColorConstant.colorP
        imgMail.image = imgMail.image?.withRenderingMode(.alwaysTemplate)
        imgCall.tintColor = ColorConstant.colorP
        imgCall.image = imgCall.image?.withRenderingMode(.alwaysTemplate)
        setThreeCorner(viewMain: viewMain)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        imgIsVerified.image = selected ? UIImage(named: "check_box") : UIImage(named: "check_box_uncheck")
//        imgIsVerified.tintColor = UIColor(named: "ColorPrimary")
//        imgIsVerified.image = imgIsVerified.image?.withRenderingMode(.alwaysTemplate)
    }
    
    func setThreeCorner(viewMain : UIView) {
        viewMain.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
    }
    @IBAction func btnCheckBoxClicked(_ sender: UIButton) {
        self.delegate.checkboxToggleButton(indexPath: indexPath)
    }
}
