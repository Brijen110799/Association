//
//  DialogAccountDeactivated.swift
//  Finca
//
//  Created by Fincasys Macmini on 27/10/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import EzPopup
import FittedSheets
class DialogAccountDeactivated: BaseVC {
    
    var Strvalue = ""
    @IBOutlet weak var btnOk:UIButton!
    @IBOutlet weak var ViewMain : UIView!
    @IBOutlet weak var BtnAddmore:UIButton!
    
    @IBOutlet weak var lblAddmore: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblAddmore.text = doGetValueLanguage(forKey: "add_more_society")
    }
    @IBAction func AddmoreEstate(_ sender: UIButton) {
        
        //dismiss(animated: true) {
           
            let nextVC = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idAddBuildingSelectLocationVC")as! AddBuildingSelectLocationVC
            nextVC.IsComeFromDialog = "1"
            self.navigationController?.pushViewController(nextVC, animated: true)
        //}
    }
    @IBAction func BtnOkClick(_ sender: UIButton) {
        
        if Strvalue == "0"
        {
            removeFromParent()
            view.removeFromSuperview()
        
           // self.dismiss(animated: true, completion: nil)
            exit(0)
        }else
        {
            //removeFromParent()
           // self.dismiss(animated: true, completion: nil)
            
            removeFromParent()
            view.removeFromSuperview()
        }
       
    }
}
