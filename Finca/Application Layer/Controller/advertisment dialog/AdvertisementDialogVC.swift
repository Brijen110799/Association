//
//  AdvertisementDialogVC.swift
//  Finca
//
//  Created by harsh panchal on 16/12/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class AdvertisementDialogVC: BaseVC {

    @IBOutlet weak var imgviewHeight: NSLayoutConstraint!
    @IBOutlet weak var imgAdvertisementBanner: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = UserDefaults.standard.string(forKey: StringConstants.BANNER_ADV_URL)
        Utils.setImageFromUrl(imageView: imgAdvertisementBanner, urlString: data!, palceHolder: "user-default")
        
    }
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
