//
//  DialogCheckUpdateVC.swift
//  Finca
//
//  Created by Fincasys Macmini on 10/02/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class DialogCheckUpdateVC: BaseVC {
    
    @IBOutlet weak var lbldesc:UILabel!
    @IBOutlet weak var lblbtntitle:UILabel!
    @IBOutlet weak var VwBtn:UIView!
    var StrCheck = ""
    
    @IBOutlet weak var bOK: UIButton!
    @IBOutlet weak var bCancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Checkversion()
        bCancel.setTitle(doGetValueLanguage(forKey: "cancel").uppercased(), for: .normal)
        bCancel.isHidden = true
    }
    func Checkversion(){
        showProgress()
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let info = Bundle.main.infoDictionary
        let identifier = info?["CFBundleIdentifier"] as? String
        let StrUrl = "http://itunes.apple.com/lookup?bundleId=" + identifier!
        let url = URL(string: StrUrl)
        let data = try! Data(contentsOf: url!)
        guard let json = try! JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {
            return
        }
        if let result = (json["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String {
            hideProgress()
            if appVersion == version
            {
                lbldesc.text =  doGetValueLanguage(forKey: "up_to_date")
                bOK.setTitle(doGetValueLanguage(forKey: "ok").uppercased(), for: .normal)
            }else
            {
                lbldesc.text = doGetValueLanguage(forKey: "new_update_available")
                bOK.setTitle(doGetValueLanguage(forKey: "update").uppercased(), for: .normal)
                bCancel.isHidden = false
            }
        }else
        {
            hideProgress()
        }
}
    @IBAction func UpdateClick (_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func CancelClick (_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func GotoAppstoreClick (_ sender: UIButton)
    {
        
        if bOK.titleLabel?.text?.lowercased() == doGetValueLanguage(forKey: "ok").lowercased() {
            dismiss(animated: true, completion: nil)
        } else {
            let openAppStoreForRating =  doGetValueLanguage(forKey: "app_url_ios")
            if let url = URL(string: openAppStoreForRating), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
    }
}
