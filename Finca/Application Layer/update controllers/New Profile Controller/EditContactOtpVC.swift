//
//  EditContactOtpVC.swift
//  Finca
//
//  Created by Fincasys Macmini on 29/10/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import DeviceKit
class EditContactOtpVC: BaseVC {

    var StrAlterNumber = ""
    var StrMobileOldnumber = ""
    var StrMobileNewnumber = ""
    var StrEmail = ""
    var StrCountryCode = ""
    var availableBalance = ""
    
    @IBOutlet weak var lbNumber: UILabel!
    @IBOutlet weak var lbCount: UILabel!
    @IBOutlet weak var viewResendOtp: UIStackView!
    @IBOutlet var lblOptBox: [CustomACFTextfield]!
    @IBOutlet weak var bResend: UIButton!
    @IBOutlet weak var heightButtonResend: NSLayoutConstraint!
    @IBOutlet weak var lbWalletMessage: UILabel!
    var context : EditContactInfoVC!
    var userProfileReponse : MemberDetailResponse!
    
    @IBOutlet weak var lbCountryCode: UILabel!
    @IBOutlet weak var bOtpCall: UIButton!
    @IBOutlet weak var lbOr: UILabel!
    
    var mobile:String!
    var society_id:String!
    var country_id : String!
    var state_id : String!
    var city_id : String!
    var countrycode = ""
    var countryName = ""
    var societyDetails : ModelSociety!
    var StrSubdomain = ""
    var count = 0
    var otp = ""
    var activeTextField :  CustomACFTextfield!
    var is_voice_otp  =  true
    override func viewDidLoad() {
        super.viewDidLoad()

        
        for index in 0...5 {
//            print(num)
            lblOptBox[index].textAlignment = .center
            doneButtonOnKeyboard(textField: lblOptBox[index])
            lblOptBox[index].delegate = self
            lblOptBox[index].deleteDelegate = self
            lblOptBox[index].isUserInteractionEnabled = false
        }
        
        _ = lblOptBox[0].becomeFirstResponder()
        lblOptBox[0].isUserInteractionEnabled = true
        
      
        doUnbleRsend()
        
        if #available(iOS 12.0, *) {
            lblOptBox[0].textContentType = .oneTimeCode
        }

        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        lbNumber.text = StrMobileNewnumber
        lbCountryCode.text = StrCountryCode
        if availableBalance != "" && availableBalance != "0.00" {
            lbWalletMessage.isHidden = false
            lbWalletMessage.text = "My Wallet : \(localCurrency()) \(availableBalance) \n\n Your current wallet amount will be transfer to your new mobile number."
        } else {
            lbWalletMessage.isHidden = true
        }
        
        
        
    }
  
  
    override func doneClickKeyboard() {
        view.endEditing(true)
    }
    @objc func update() {
        if(count > 0) {
            count = count - 1
            lbCount.text =  "00:" + String(format: "%02d", count)
        }else {
            lbCount.text =  "00:00"
            viewResendOtp.isHidden = false
            
            if is_voice_otp {
                bOtpCall.isHidden = false
                lbOr.isHidden = false
            } else{
                bOtpCall.isHidden = true
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if let text = textField.text {
            
            // 10. when the user enters something in the first textField it will automatically adjust to the next textField and in the process do some disabling and enabling. This will proceed until the last textField
            if (text.count < 1) && (string.count > 0) {
                
                if textField == lblOptBox[0] {
                    lblOptBox[0].isUserInteractionEnabled = false
                    lblOptBox[1].isUserInteractionEnabled = true
                    _ = lblOptBox[1].becomeFirstResponder()
                }
                
                if textField == lblOptBox[1] {
                    lblOptBox[1].isUserInteractionEnabled = false
                    lblOptBox[2].isUserInteractionEnabled = true
                    _ = lblOptBox[2].becomeFirstResponder()
                }
                
                if textField == lblOptBox[2] {
                    lblOptBox[2].isUserInteractionEnabled = false
                    lblOptBox[3].isUserInteractionEnabled = true
                    _ = lblOptBox[3].becomeFirstResponder()
                }
                if textField == lblOptBox[3] {
                    lblOptBox[3].isUserInteractionEnabled = false
                    lblOptBox[4].isUserInteractionEnabled = true
                    _ = lblOptBox[4].becomeFirstResponder()
                }
                
                if textField == lblOptBox[4] {
                    lblOptBox[4].isUserInteractionEnabled = false
                    lblOptBox[5].isUserInteractionEnabled = true
                    _ = lblOptBox[5].becomeFirstResponder()
                }
                
                if textField == lblOptBox[5] {
                    //
                    print("call api")
                    //checkAllFilled()
                    Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.callApi), userInfo: nil, repeats: false)
                    _ = lblOptBox[5].resignFirstResponder()
                }
                
                textField.text = string
                return false
                
            } // 11. if the user gets to the last textField and presses the back button everything above will get reversed
            else if (text.count >= 1) && (string.count == 0) {
                
                if textField == lblOptBox[1] {
                    lblOptBox[1].isUserInteractionEnabled = false
                    lblOptBox[0].isUserInteractionEnabled = true
                    _ = lblOptBox[0].becomeFirstResponder()
                    lblOptBox[0].text = ""
                }
                
                
                if textField == lblOptBox[2] {
                    lblOptBox[2].isUserInteractionEnabled = false
                    lblOptBox[1].isUserInteractionEnabled = true
                    _ = lblOptBox[1].becomeFirstResponder()
                    lblOptBox[1].text = ""
                }
                
                if textField == lblOptBox[3] {
                    lblOptBox[3].isUserInteractionEnabled = false
                    lblOptBox[2].isUserInteractionEnabled = true
                    _ = lblOptBox[2].becomeFirstResponder()
                    lblOptBox[2].text = ""
                }
                
                if textField == lblOptBox[4] {
                    lblOptBox[4].isUserInteractionEnabled = false
                    lblOptBox[3].isUserInteractionEnabled = true
                    _ = lblOptBox[3].becomeFirstResponder()
                    lblOptBox[3].text = ""
                }
                if textField == lblOptBox[5] {
//                    lblOptBox[5].isUserInteractionEnabled = false
//                    lblOptBox[4].isUserInteractionEnabled = true
//                    lblOptBox[4].becomeFirstResponder()
                    lblOptBox[5].text = ""
                }
                
                
                if textField == lblOptBox[0] {
                    // do nothing
                }
                
                textField.text = ""
                return false
                
            } // 12. after pressing the backButton and moving forward again you will have to do what's in step 10 all over again
            else if text.count >= 1 {
                
                if textField == lblOptBox[0] {
                    lblOptBox[0].isUserInteractionEnabled = false
                    lblOptBox[1].isUserInteractionEnabled = true
                    _ =  lblOptBox[1].becomeFirstResponder()
                }
                
                
                if textField == lblOptBox[1] {
                    lblOptBox[1].isUserInteractionEnabled = false
                    lblOptBox[2].isUserInteractionEnabled = true
                    _ =  lblOptBox[2].becomeFirstResponder()
                }
                if textField == lblOptBox[2] {
                    lblOptBox[2].isUserInteractionEnabled = false
                    lblOptBox[3].isUserInteractionEnabled = true
                    _ = lblOptBox[3].becomeFirstResponder()
                }
                if textField == lblOptBox[3] {
                    lblOptBox[3].isUserInteractionEnabled = false
                    lblOptBox[4].isUserInteractionEnabled = true
                    _ = lblOptBox[4].becomeFirstResponder()
                }
                if textField == lblOptBox[4] {
                    lblOptBox[4].isUserInteractionEnabled = false
                    lblOptBox[5].isUserInteractionEnabled = true
                    _ = lblOptBox[5].becomeFirstResponder()
                }
                
                
                
                
                if textField == lblOptBox[5] {
                    // do nothing or better yet do something now that you have all four digits for the sms code. Once the user lands on this textField then the sms code is complete
                  //  checkAllFilled()
                    _ =  lblOptBox[5].resignFirstResponder()
                    
                }
                
                textField.text = string
                return false
            }
        }
        return true
    }
    
    @IBAction func textEditDidBegin(_ sender: ACFloatingTextfield) {
        activeTextField = sender as? CustomACFTextfield
        
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 100
        }
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
        
    }
   
    @objc func callApi() {
        otp = userInputCombineString()
        if otp == "" ||  otp.count < 6 {
            showAlertMessage(title: "", msg: "Enter valid OTP")
        } else {
            doCallLogin()
        }
    }
    
    func userInputCombineString()->String{
        var string = ""
        for field in lblOptBox{
            string.append(field.text!)

        }
        return string
    }
    func doUnbleRsend() {
        self.count = 60
        viewResendOtp.isHidden = true
        //        heightButtonResend.constant = 0

    }
    @IBAction func onClickVerify(_ sender: Any) {

        otp = userInputCombineString()
        if otp == "" ||  otp.count < 6 {
            showAlertMessage(title: "", msg: "Enter valid Otp")
        } else {
            doCallLogin()
            
           
        }
    }
    @IBAction func onClickClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
   
    func getMultiunitCall(Newmobilenumber:String)
    {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let device = Device.current
        let params = ["getMultiUnitsNew":"getMultiUnitsNew",
                      "user_mobile":doGetLocalDataUser().userMobile!,
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_token": UserDefaults.standard.string(forKey: StringConstants.KEY_DEVICE_TOKEN)!,
                      "app_version_code" : appVersion!,
                      "phone_brand":"Apple",
                      "device":"ios",
                      "phone_model":device.description,
                      "country_code":doGetLocalDataUser().countryCode ?? ""]
        
        print(params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.residentDataUpdateController, parameters: params) { (Data, Err) in
            if Data != nil{
                //                self.hideProgress()
                print(Data as Any)
                do {
                    let response = try JSONDecoder().decode(MultiUnitResponse.self, from: Data!)
                    if response.status == "200"{
                        let unitList : [LoginResponse]! = response.units
                        for item in unitList{
                            if item.unitID == BaseVC().doGetLocalDataUser().unitID!{
                                if let encoded = try? JSONEncoder().encode(item) {
                                    UserDefaults.standard.set(encoded, forKey: StringConstants.KEY_LOGIN_DATA)
                                }
                            }
                        }

                    }else{

                    }
                }catch{
                    print("Parse Error",Err as Any)
                }
            }else{

            }
        }
    }
    
    func  doCallLogin() {
        let IsFirebase = UserDefaults.standard.bool(forKey: StringConstants.KEY_IS_FIREBASE)
        print(IsFirebase)
        showProgress()
        
        let params = ["society_id":society_id ?? "",
                      "user_verify_new_mobile":"user_verify_new_mobile",
                      "old_mobile":StrMobileOldnumber,
                      "new_mobile":StrMobileNewnumber,
                      "user_token":UserDefaults.standard.string(forKey: StringConstants.KEY_DEVICE_TOKEN)!,
                      "device":"ios",
                      "otp":otp,
                      "user_email":self.doGetLocalDataUser().userEmail ?? "",
                      "alt_mobile":StrAlterNumber,
                      "is_firebase":"\(IsFirebase)",
                      "country_code":doGetLocalDataUser().countryCode ?? "",
                      "country_code_new":StrCountryCode]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        requrest.requestPost(serviceName: ServiceNameConstants.otp_controller, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil
            {
                if json != nil {
                    do {
                        let response = try JSONDecoder().decode(LoginResponse.self, from:json!)
                        if response.status == "200"{
                            
                            print(response)
                         
                            self.dismiss(animated: false, completion: {
                                
                                 if let encoded = try? JSONEncoder().encode(response) {
                                    UserDefaults.standard.set(encoded, forKey: StringConstants.KEY_LOGIN_DATA)
                                }
                                self.context.doPopman()
                            })
                            
                        }else{
                            self.showAlertMessage(title: "", msg: response.message ?? "")
                        }
                    } catch {
                        print("parse error")
                    }
                }
            }
        }
    }
    @IBAction func onClickResend(_ sender: UIButton) {
        doCallUpdateApi(otpType: String(sender.tag) )
        //doSendOtp(otpType:String(sender.tag))
    }
    func doSendOtp(otpType : String! = "0") {
        
        let IsFirebase = UserDefaults.standard.bool(forKey: StringConstants.KEY_IS_FIREBASE)
        print(IsFirebase)
        showProgress()
       
        let params = ["key":apiKey(),
                      "user_login_new":"user_login_new",
                      "user_mobile":StrMobileNewnumber,
                      "society_id":society_id!,
                      "is_firebase":"\(IsFirebase)",
                      "otp_type":otpType!,
                      "country_code":self.countrycode]
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        requrest.requestPost(serviceName: ServiceNameConstants.otp_controller, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                print(json as Any)
                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from:json!)
                    
                    
                    if loginResponse.status == "200" {
                        self.doUnbleRsend()
                        
                    }else {
                        //                        UserDefaults.standard.set("0", forKey: StringConstants.KEY_LOGIN)
                        self.showAlertMessage(title: "Alert", msg: loginResponse.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    func doCallUpdateApi(otpType : String){
        
        let IsFirebase = UserDefaults.standard.bool(forKey: StringConstants.KEY_IS_FIREBASE)
        showProgress()
        
        let params = ["key":apiKey(),
                      "setProsnalDetails":"setProsnalDetails",
                      "user_full_name":  "",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_first_name":"",
                      "user_last_name":"",
                      "user_email":"",
                      "alt_mobile":"",
                      "member_date_of_birth":"",
                      "facebook":"",
                      "instagram":"",
                      "linkedin":"",
                      "gender":"",
                      "blood_group":"",
                      "new_mobile":StrMobileNewnumber,
                      "country_code":StrCountryCode,
                      "country_code_alt":"",
                      "is_firebase":"\(IsFirebase)",
                      "otp_lenght":"6",
                      "old_mobile":self.doGetLocalDataUser().userMobile ?? "",
                      "otp_type":otpType]
        
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.resident_data_update_controller2, parameters: params) { [self] (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    if response.status == "200" {
                        
                        self.doUnbleRsend()
                        
                        
                        
                        //                        self.showAlertMessage(title: "", msg: response.message)
                    }else {
                        //                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
}
extension EditContactOtpVC: ACFloatingTextfieldDeleteActionDelegate {
    func textFieldDidSelectDeleteButton(_ textField: ACFloatingTextfield) {
        if activeTextField == lblOptBox[0] {
            print("backButton was pressed in txtOTPBox[0]")
            // do nothing
        }
        
        if activeTextField == lblOptBox[1] {
            print("backButton was pressed in txtOTPBox[1]")
            lblOptBox[1].isUserInteractionEnabled = false
            lblOptBox[0].isUserInteractionEnabled = true
            _ = lblOptBox[1].becomeFirstResponder()
            lblOptBox[0].text = ""
        }
        
        
        if activeTextField == lblOptBox[2] {
            print("backButton was pressed in txtOTPBox[2]")
            lblOptBox[2].isUserInteractionEnabled = false
            lblOptBox[1].isUserInteractionEnabled = true
            _ = lblOptBox[2].becomeFirstResponder()
            lblOptBox[1].text = ""
        }
        
        
        if activeTextField == lblOptBox[3] {
            print("backButton was pressed in txtOTPBox[3]")
            lblOptBox[3].isUserInteractionEnabled = false
            lblOptBox[2].isUserInteractionEnabled = true
            _ = lblOptBox[3].becomeFirstResponder()
            lblOptBox[2].text = ""
        }
        
        
        if activeTextField == lblOptBox[4] {
            print("backButton was pressed in txtOTPBox[4]")
            lblOptBox[4].isUserInteractionEnabled = false
            lblOptBox[3].isUserInteractionEnabled = true
            _ = lblOptBox[4].becomeFirstResponder()
            lblOptBox[3].text = ""
        }
        
        if activeTextField == lblOptBox[5] {
            print("backButton was pressed in txtOTPBox[5]")
            if lblOptBox[5].text != "" {
                lblOptBox[5].text = ""
                return
            }else {
                lblOptBox[5].isUserInteractionEnabled = false
                lblOptBox[4].isUserInteractionEnabled = true
                _ =  lblOptBox[5].resignFirstResponder()
                lblOptBox[4].text = ""
            }
            
            
        }
    }
}
