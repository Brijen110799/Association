//
//  DialogNotificationSound.swift
//  Finca
//
//  Created by Fincasys Macmini on 29/01/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit

class DialogNotificationSound: BaseVC {

    var context : SettingsVC!
    var context1 : FinAddCustomerDialogVC!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func BtnCancelClicked(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func btnSettingClicked(_ sender: UIButton) {
       
        dismiss(animated: true) {
            
            if let appSettings = NSURL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings as URL, options: [:], completionHandler: nil)
            }
            
        }
    }
}




