//
//  DialogAppUpdateVC.swift
//  Finca
//
//  Created by Fincasys Macmini on 20/01/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit

class DialogAppUpdateVC: BaseVC {
    
    @IBOutlet weak var lblVersion : UILabel!
    @IBOutlet weak var lbAppname: UILabel!
    
    
    var StrVersion = ""
    var appurl = ""
    var appName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblVersion.text = "Version \(StrVersion)"
        lbAppname.text = appName
    }
    @IBAction func UpdateClick (_ sender: UIButton)
    {
        
  // let urlStr = "https://apps.apple.com/in/app/fincasys/id1472966034"
    // let appurl  = "https://apps.apple.com/kh/app/my-association-app/id1565765469"
        
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: appurl )!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL(string: appurl )!)
        }
        
    }
}
