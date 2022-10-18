//
//  CustomNotificationShowVC.swift
//  Finca
//
//  Created by Fincasys Macmini on 25/11/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class CustomNotificationShowVC: BaseVC {
    
    @IBOutlet weak var imgvw : UIImageView!
    @IBOutlet weak var lbltitle:UILabel!
    @IBOutlet weak var lbldate:UILabel!
    @IBOutlet weak var lblinfo:UITextView!
    @IBOutlet weak var Vwmain : UIView!
    var Strtitle = ""
    var Strdate = ""
    var Strinfo = ""
    var StrImageUrl = ""
    var IsComeFromCustomNotify = ""
    var image = UIImage()
    var CustomNotify : FcmCustomNotify!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblinfo.isSelectable = true
        lblinfo.isEditable = false
        if Strtitle == ""
        {
        
            lbltitle.text = CustomNotify.title
            lbldate.text = CustomNotify.notification_time
            lblinfo.text = CustomNotify.description
            Utils.setImageFromUrl(imageView: imgvw, urlString: CustomNotify.img_url ?? "", palceHolder: "advertisements")
                Vwmain.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
            
        }else
        {
            lbltitle.text = Strtitle
            lbldate.text = Strdate
            lblinfo.text = Strinfo
            Utils.setImageFromUrl(imageView: imgvw, urlString: StrImageUrl, palceHolder: "advertisements")
            Vwmain.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
        }
    }
    @IBAction func BackClick(_ sender: Any) {
        
        if IsComeFromCustomNotify == "1"
        {
            Utils.setHome()
            
        }else{
            doPopBAck()
        }
    }
}
