//
//  AddCommercialVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 28/08/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

struct CommercialUsersResponse : Codable {
    let status : String! //" : "200"
    let message : String! //" : "Commercial Users List",
    let commercial_users : [ModelCommercialUsers]!
}
struct ModelCommercialUsers : Codable {
    let phone  :String! //" : "2546879008",
    let society_id  :String! //" : "75",
    let user_entry_id  :String! //" : "18",
    let unit_id  :String! //" : "3152",
    let name  :String! //" : "Deepak"
}

class AddCommercialVC: BaseVC {

    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfMobile: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var lblCommercialName: UILabel!
    @IBOutlet weak var lblCommercialMobileNo: UILabel!
    @IBOutlet weak var lblCommercialPassWrd: UILabel!
    @IBOutlet weak var lblCommercialConfirmPassWrd: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    var context : UserProfileVC!
let ACCEPTABLE_CHARACTERS = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tfName.delegate = self
        
        tfName.placeholder(doGetValueLanguage(forKey: "type_here"))
        tfMobile.placeholder(doGetValueLanguage(forKey: "type_here"))
        tfPassword.placeholder(doGetValueLanguage(forKey: "type_here"))
        tfConfirmPassword.placeholder(doGetValueLanguage(forKey: "type_here"))
        lblCommercialName.text = doGetValueLanguage(forKey: "name")
        lblCommercialMobileNo.text = doGetValueLanguage(forKey: "mobile_number_commercial")
        lblCommercialPassWrd.text = doGetValueLanguage(forKey: "password")
        lblCommercialConfirmPassWrd.text = doGetValueLanguage(forKey: "confirm_password")
        btnAdd.setTitle(doGetValueLanguage(forKey: "add").uppercased(), for: .normal)
        btnCancel.setTitle(doGetValueLanguage(forKey: "cancel").uppercased(), for: .normal)
    }
    
    
   
    @IBAction func tapAdd(_ sender: Any) {
        if isValidate() {
            doAddEntry()
        }
        
    }
    @IBAction func tapCAncel(_ sender: Any) {
         self.sheetViewController?.dismiss(animated: false, completion: nil)
    }
    
    
  
    func isValidate() -> Bool {
           var validate = true
          
        if (tfName.text?.isEmptyOrWhitespace())!  {
            showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_valid_name"))
            validate = false
        }
        if tfMobile.text!.count < 8 {
            showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_valid_mobile_number"))
            validate = false
        }
        if tfPassword.text!.count < 6 {
            showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "password_must_have_minimum_characters"))
            validate = false
        } else {
            
            if tfPassword.text != tfConfirmPassword.text {
                showAlertMessage(title: "", msg:doGetValueLanguage(forKey: "password_dont_match"))
                validate = false
            }
            
        }
        return validate
    }
    func setNameAndNumber(number : String , name: String) {
        tfName.text = name
        var conatct = ""
        
        
        if number.contains("+") {
            conatct = String(number.dropFirst(3))
            conatct = conatct.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        } else if number.contains("-") {
            conatct = number.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
            conatct = conatct.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        }else {
            conatct = number.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        }
        
        
        tfMobile.text = conatct
        
    }
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if textField == tfName  {
                let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
                let filtered = string.components(separatedBy: cs).joined(separator: "")
                
                return (string == filtered)
                
            }
            return true
        }
        
        
    
    
    func doAddEntry() {
           showProgress()
           let params = ["addcommercialUser":"addcommercialUser",
                         "society_id":doGetLocalDataUser().societyID!,
                         "unit_id":doGetLocalDataUser().unitID!,
                         "name":tfName.text!,
                         "password":tfPassword.text!,
                         "phone":tfMobile.text!]
           
           
           print("param" , params)
           
           let requrest = AlamofireSingleTon.sharedInstance
           requrest.requestPost(serviceName: ServiceNameConstants.commercial_portal_controller, parameters: params) { (json, error) in
               self.hideProgress()
               if json != nil {
                   
                   do {
                       let response = try JSONDecoder().decode(CommercialUsersResponse.self, from:json!)
                       
                       
                       if response.status == "200" {
                           //                    self.profilePersonalDetailVC.isAddEmergancyMember = true
                           self.sheetViewController!.dismiss(animated: false) {
                               self.context.refreshPage()
                           }
                           
                       }else {
                           self.showAlertMessage(title: "", msg: response.message)
                       }
                   } catch {
                       print("parse error")
                   }
               }
           }
       }
}
