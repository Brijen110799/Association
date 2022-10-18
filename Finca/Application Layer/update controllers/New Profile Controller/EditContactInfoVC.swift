//
//  EditContactInfoVC.swift
//  Fincasys
//
//  Created by silverwing_macmini3 on 11/23/1398 AP.
//  Copyright © 1398 silverwing_macmini3. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import EzPopup

class EditContactInfoVC: BaseVC {
    @IBOutlet weak var viewDisplay: UIView!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfAltMobile: UITextField!
    @IBOutlet weak var tfMobileNumber: UITextField!
    @IBOutlet weak var lblCountryNameCode: UILabel!
    @IBOutlet weak var lblAltCountryNameCode: UILabel!
    @IBOutlet weak var lblEmailIDTitle: UILabel!
    @IBOutlet weak var lblMobileNumberTitle: UILabel!
    @IBOutlet weak var lblAlternateMobileTItle: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    var PopUpFlag = Bool()
    var societyDetails : ModelSociety!
    var context : UserDetailVC!
    var userProfileReponse : MemberDetailResponse!
    var userDetail : MemberDetailModal!
    var GetData : CommonResponse!
    var StrOldAltnumber = ""
    var StrNewAltnumber = ""
    var StrOldMobiletnumber = ""
    var StrNewMobiletnumber = ""
    var StrComeFromContactInfo = ""
    var phoneCode = "+91"
    var phoneCode1 = ""
    var countryName = "India"
    var countryCode = ""
    var countryList = CountryList()
    var tag : Int!
    var click = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewDisplay.layer.cornerRadius = 20
        tfMobileNumber.text = self.userProfileReponse.userMobile!
        tfEmail.text = self.userProfileReponse.userEmail!
        tfAltMobile.text = self.userProfileReponse.altMobile == "0" ? "" : self.userProfileReponse.altMobile
        lblAltCountryNameCode.text = userProfileReponse.countryCodeAlt
        lblCountryNameCode.text = userProfileReponse.countryCode
        tfEmail.placeholder(doGetValueLanguage(forKey: "type_here"))
        tfMobileNumber.placeholder(doGetValueLanguage(forKey: "type_here"))
        tfAltMobile.placeholder(doGetValueLanguage(forKey: "type_here"))
        lblEmailIDTitle.text = doGetValueLanguage(forKey: "email_ID")
        lblMobileNumberTitle.text = doGetValueLanguage(forKey: "mobile_number")
        lblAlternateMobileTItle.text = doGetValueLanguage(forKey: "alternate_mobile_number")
        btnCancel.setTitle(doGetValueLanguage(forKey: "cancel").uppercased(), for: .normal)
        btnUpdate.setTitle(doGetValueLanguage(forKey: "update").uppercased(), for: .normal)
        countryList.delegate = self
        tfMobileNumber.keyboardType = .numberPad
        
        if  userProfileReponse.countryCodeAlt ?? "" != "" {
            phoneCode1 = userProfileReponse.countryCodeAlt
            //lblAltCountryNameCode.text = userProfileReponse.countryCodeAlt
        }else{
            setDefultCountry()
 }
        if  userProfileReponse.countryCode ?? "" != ""{
            phoneCode = userProfileReponse.countryCode
            //lblCountryNameCode.text = userProfileReponse.countryCode
        }else{
            setDefultCountry()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.addKeyboardAccessory(textFields: [tfEmail,tfMobileNumber,tfAltMobile])
       // tfMobileNumber.delegate = self
        //setDefultCountry()
       
     //   print("CC \(doGetLocalDataUser().countryCodeAlt ?? "Not-Found")")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if self.view.frame.origin.y == 0 {
//            self.view.frame.origin.y -= 220
//        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {

        self.view.frame.origin.y = 0
    }
    
    @objc  func keyboardWillShow(sender: NSNotification) {
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
       
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardHeight 
        }
       
    }
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return view.endEditing(true)
    }
    func setDefultCountry(){
      
        let localRegion =  Locale.current.regionCode
        let count = Countries()
        for item in count.countries {
            if item.countryCode == localRegion{
                lblCountryNameCode.text = "\(item.flag!) (\(item.countryCode)) +\(item.phoneExtension)"
                self.countryName = item.name!
                self.countryCode = item.countryCode
                self.phoneCode = "+" + item.phoneExtension
                break
            }
        }
        for item in count.countries {
            if item.countryCode == localRegion{
                lblAltCountryNameCode.text = "\(item.flag!) (\(item.countryCode)) +\(item.phoneExtension)"
                self.countryName = item.name!
                self.countryCode = item.countryCode
                self.phoneCode1 = "+" + item.phoneExtension
                break
            }
        }
    }
    func doValidate()-> Bool{
        var flag = true
         if tfEmail.text != ""{
             if !isValidEmail(email: tfEmail.text ?? "") {
                 flag = false
                 self.showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_valid_email"))
             }
         }
        if tfMobileNumber.text!.count < 8{
            flag = false
            self.showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_valid_mobile_number"))
        }
        
        if tfAltMobile.text != ""{
            if tfAltMobile.text!.count < 8{
                flag = false
                self.showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_valid_mobile_number"))
            }
        }
        return flag
    }
    @IBAction func btnUpdateClicked(_ sender: UIButton) {
        
        self.tfEmail.resignFirstResponder()
        self.tfMobileNumber.resignFirstResponder()
        self.tfAltMobile.resignFirstResponder()
        
        self.view.frame.origin.y = 0
        
        var bG  = self.userProfileReponse.blood_group ?? ""
        
        if bG.contains(doGetValueLanguage(forKey: "not_available")){
            bG = ""
        }
        if doValidate(){
            
            doCallUpdateApi(firstName: self.userProfileReponse.userFirstName!, lastName: self.userProfileReponse.userLastName!, middleName: self.userProfileReponse.user_middle_name, email: self.tfEmail.text!, alt_mobile: self.tfAltMobile.text!, DOB: self.userProfileReponse.memberDateOfBirth!, facebook: self.userProfileReponse.facebook!, instagram: self.userProfileReponse.instagram!, linkedin: self.userProfileReponse.linkedin!,gender: self.doGetLocalDataUser().gender!, blood_group: bG, usermobile: self.tfMobileNumber.text!, phoneCode1: phoneCode1, phoneCode: phoneCode)

            }
        
    }
    func doGetProfile(){
        let params = ["key":apiKey(),
                      "getProfileData":"getProfileData",
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!]
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.residentDataUpdateController, parameters: params) { (json, error) in
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(MemberDetailResponse.self, from:json!)
                    if response.status == "200"{
                        
//                        print(response)
                        if let encoded = try? JSONEncoder().encode(response) {
                           UserDefaults.standard.set(encoded, forKey: StringConstants.KEY_LOGIN_DATA)
                       }
                        
                        self.context.userProfileReponse = response
                        self.context.doInitUI()
                     
                    }else{
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    func doPopman()
    {
    
//        self.sheetViewController?.dismiss(animated: true, completion: {
//            self.context.doGetProfile()
//
//        })
        removePopView()
        self.context.doGetProfile()
    }
    func doCallUpdateApi(firstName:String!,
                         lastName:String!,
                         middleName:String!,
                         email:String!,
                         alt_mobile:String!,
                         DOB:String!,
                         facebook:String!,
                         instagram:String!,
                         linkedin:String!,
                         gender:String!,
                         blood_group:String,
                         usermobile:String,
                         phoneCode1:String!,
                         phoneCode:String!){
        
        let IsFirebase = UserDefaults.standard.bool(forKey: StringConstants.KEY_IS_FIREBASE)
        showProgress()
        let full_name = firstName + " " + lastName
        var member_date_of_birth = ""
        if DOB.contains(doGetValueLanguage(forKey: "not_available")){
            member_date_of_birth = ""
        } else {
            member_date_of_birth = DOB
        }
        let params = ["key":apiKey(),
                      "setProsnalDetails":"setProsnalDetails",
                      "user_full_name":  full_name,
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_first_name":firstName!,
                      "user_last_name":lastName!,
                      "user_email":email!,
                      "alt_mobile":alt_mobile!,
                      "member_date_of_birth":member_date_of_birth,
                      "facebook":facebook!,
                      "instagram":instagram!,
                      "linkedin":linkedin!,
                      "gender":gender!,
                      "blood_group":blood_group,
                      "new_mobile":usermobile,
                      "country_code":phoneCode!,
                      "country_code_alt":phoneCode1!,
                      "is_firebase":"\(IsFirebase)",
                      "otp_lenght":"6",
                      "old_mobile":self.doGetLocalDataUser().userMobile ?? ""]
        
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.resident_data_update_controller2, parameters: params) { [self] (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    if response.status == "200" {
                        
                        self.PopUpFlag = response.otp_popup
                       // Utils.updateLocalUserData()
                        
                        if response.otp_popup {
                            self.showOtpDailog(walletBal: response.availableBalance ?? "", is_voice_otp: response.is_voice_otp)
                        } else {
                           // self.doGetProfile()
                            self.context.doUpdateData()
                           // self.context.userProfileReponse = response
                           // self.context.doInitUI()
                            //self.sheetViewController?.dismiss(animated: false)
                            self.removePopView()
                            self.toast(message: response.message, type: .Information)
                           
                       }
//                        if self.tfMobileNumber.text == self.doGetLocalDataUser().userMobile || self.PopUpFlag == true
//                        {
//                            self.doGetProfile()
//                            self.sheetViewController?.dismiss(animated: false)
//                            self.toast(message: response.message, type: .Information)
//
//                        }else
//                        {
//                            self.showOtpDailog(walletBal: response.availableBalance ?? "")
//                        }
                        
                        
                        
//                        self.showAlertMessage(title: "", msg: response.message)
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    @IBAction func onClickCancel(_ sender: Any) {
       //sheetViewController?.dismiss(animated: false, completion: nil)
        removePopView()
    }
    func showOtpDailog(walletBal : String,is_voice_otp:Bool) {
        let screenwidth = UIScreen.main.bounds.width
               let screenheight = UIScreen.main.bounds.height
        let vc = subStoryboard.instantiateViewController(withIdentifier: "EditContactOtpVC") as! EditContactOtpVC
        vc.context = self
        vc.StrAlterNumber = tfAltMobile.text!
        vc.StrMobileOldnumber = self.doGetLocalDataUser().userMobile
        vc.StrMobileNewnumber = tfMobileNumber.text!
        vc.StrEmail = tfEmail.text!
        vc.StrCountryCode  = phoneCode
        vc.availableBalance = walletBal
        vc.society_id = doGetLocalDataUser().societyID!
        vc.is_voice_otp = is_voice_otp
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth-10  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
        
    }
    func updateCall() {
        doCallUpdateApi(firstName: self.userProfileReponse.userFirstName!, lastName: self.userProfileReponse.userLastName!, middleName: self.userProfileReponse.user_middle_name!, email: self.tfEmail.text!, alt_mobile: self.tfAltMobile.text!, DOB: self.userProfileReponse.memberDateOfBirth!, facebook: self.userProfileReponse.facebook!, instagram: self.userProfileReponse.instagram!, linkedin: self.userProfileReponse.linkedin!,gender: self.doGetLocalDataUser().gender!, blood_group: self.userProfileReponse.blood_group ?? "", usermobile: self.tfMobileNumber.text!, phoneCode1: phoneCode1, phoneCode: phoneCode)
        
    }
    @IBAction func btnSelectCountry(_ sender: UIButton) {
        tag = sender.tag
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
    }
}
extension EditContactInfoVC : CountryListDelegate {
   
    func selectedCountry(country: Country) {
        if tag == 0 {

                lblCountryNameCode.text = "+\(country.phoneExtension)"

                self.countryName = country.name!
                self.countryCode = country.countryCode
                self.phoneCode = "+\(country.phoneExtension)"
            
        }else if tag == 1{
            lblAltCountryNameCode.text = "+\(country.phoneExtension)"
           
                       self.countryName = country.name!
                       self.countryCode = country.countryCode
                       self.phoneCode1 = "+\(country.phoneExtension)"
        }
       
//        else if phoneCode1 == lblAltCountryNameCode.text!{
//            lblAltCountryNameCode.text = "\(country.flag!) (\(country.countryCode)) +\(country.phoneExtension)"
//
//            self.countryName = country.name!
//            self.countryCode = country.countryCode
//            self.phoneCode1 = "+\(country.phoneExtension)"
//        }
        
    }
}
