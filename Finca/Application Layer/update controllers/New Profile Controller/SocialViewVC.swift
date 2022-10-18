//
//  SocialViewVC.swift
//  DemoOne
//
//  Created by Silverwing_macmini5 on 13/02/20.
//  Copyright © 2020 Silverwing_macmini5. All rights reserved.
//

import UIKit
import FittedSheets

class SocialViewVC: BaseVC {
    @IBOutlet weak var viewRadius: UIView!
    @IBOutlet weak var tfFacebook: UITextField!
    @IBOutlet weak var tfInstagram: UITextField!
    @IBOutlet weak var tfLinkedin: UITextField!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    var context : UserDetailVC!
    var userProfileReponse : MemberDetailResponse!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewRadius.layer.cornerRadius = viewRadius.bounds.height / 12
        viewRadius.layer.masksToBounds = true
        self.tfFacebook.text = userProfileReponse.facebook
        self.tfLinkedin.text = userProfileReponse.linkedin
        self.tfInstagram.text = userProfileReponse.instagram
        
        tfFacebook.placeholder(doGetValueLanguage(forKey: "enter_link_here"))
        tfInstagram.placeholder(doGetValueLanguage(forKey: "enter_link_here"))
        tfLinkedin.placeholder(doGetValueLanguage(forKey: "enter_link_here"))
        btnUpdate.setTitle(doGetValueLanguage(forKey: "update").uppercased(), for: .normal)
        btnCancel.setTitle(doGetValueLanguage(forKey: "cancel").uppercased(), for: .normal)
        
        self.addKeyboardAccessory(textFields: [self.tfLinkedin,self.tfFacebook,self.tfInstagram])
        
        
    }
    
    @IBAction func onClickCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func btnUpdateClicked(_ sender: UIButton) {
        
        self.tfFacebook.resignFirstResponder()
        self.tfInstagram.resignFirstResponder()
        self.tfLinkedin.resignFirstResponder()
       
        
        self.view.frame.origin.y = 0
        
        
        self.sheetViewController?.dismiss(animated: false, completion: {
            self.context.doCallUpdateApi(firstName: self.userProfileReponse.userFirstName!, middleName: self.userProfileReponse.user_middle_name!, lastName: self.userProfileReponse.userLastName!, email: self.userProfileReponse.userEmail!, alt_mobile: self.userProfileReponse.altMobile!, DOB: self.userProfileReponse.memberDateOfBirth, facebook: self.tfFacebook.text!, instagram: self.tfInstagram.text!, linkedin: self.tfLinkedin.text!,gender: self.doGetLocalDataUser().gender!, blood_group: self.userProfileReponse.blood_group ?? "", usermobile: "",phoneCode1: self.userProfileReponse.countryCodeAlt, phoneCode: self.userProfileReponse.countryCode)
        })
    }
}
