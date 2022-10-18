//
//  DialogBuyPropertyVC.swift
//  Finca
//
//  Created by Fincasys Macmini on 19/03/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit

class DialogBuyPropertyVC: BaseVC {
    @IBOutlet weak var lblname:UILabel!
    @IBOutlet weak var lblMobileNo:UILabel!
    var Strname = ""
    var StrMobile = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblname.text = Strname
        lblMobileNo.text = StrMobile
    }
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
