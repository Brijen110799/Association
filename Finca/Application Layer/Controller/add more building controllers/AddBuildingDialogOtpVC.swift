//
//  AddBuildingDialogOtpVC.swift
//  Finca
//
//  Created by harsh panchal on 02/01/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
class AddBuildingDialogOtpVC: BaseVC {
    
    @IBOutlet weak var tfNumberOne: UITextField!
    @IBOutlet weak var tfNumberTwo: UITextField!
    @IBOutlet weak var tfNumberThree: UITextField!
    @IBOutlet weak var tfNumberFour: UITextField!
    
    @IBOutlet weak var lbCountryCode: UILabel!
    @IBOutlet weak var lbNumber: UILabel!
    @IBOutlet weak var lbCount: UILabel!
    @IBOutlet weak var viewResendOtp: UIStackView!
    @IBOutlet var txtOTPBox: [CustomACFTextfield]!
    @IBOutlet weak var bResend: UIButton!
    @IBOutlet weak var heightButtonResend: NSLayoutConstraint!
    
    @IBOutlet weak var lbOtpVerification: UILabel!
    @IBOutlet weak var lbEnterOtp: UILabel!
   // @IBOutlet weak var lbOR: UILabel!
    @IBOutlet weak var lbORSecond: UILabel!
   
    @IBOutlet weak var bSendEmail: UIButton!
    @IBOutlet weak var bCall: UIButton!
    
    @IBOutlet weak var bCancel: UIButton!
    @IBOutlet weak var bVerify: UIButton!
    @IBOutlet weak var svResendMailAndCall: UIStackView!
    var context : AddBuildingLoginVC!
    var mobile:String!
    var society_id:String!
    var country_id : String!
    var state_id : String!
    var city_id : String!
    var countrycode = ""
    var countryName = ""
    var societyDetails : ModelSociety!
    var count = 0
    var otp = ""
    var activeTextField :  CustomACFTextfield!
    var is_email_otp  = true
    var is_voice_otp  = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for index in 0...5 {
            txtOTPBox[index].textAlignment = .center
            doneButtonOnKeyboard(textField: txtOTPBox[index])
            txtOTPBox[index].delegate = self
            txtOTPBox[index].deleteDelegate = self
            txtOTPBox[index].isUserInteractionEnabled = false
        }
        
        _ = txtOTPBox[0].becomeFirstResponder()
        txtOTPBox[0].isUserInteractionEnabled = true
        
        if #available(iOS 12.0, *) {
            txtOTPBox[0].textContentType = .oneTimeCode
        }
        doUnbleSend()
        
        lbCountryCode.text = countrycode
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        lbNumber.text = mobile
     
        setUI()
    }
    func setUI() {
        lbOtpVerification.text = doGetValueLanguage(forKey: "otp_verification")
        lbEnterOtp.text = doGetValueLanguage(forKey: "please_enter_OTP_below")
        
       // lbOR.text = doGetValueLanguage(forKey: "or")
        lbORSecond.text = doGetValueLanguage(forKey: "or")
        bResend.setTitle(doGetValueLanguage(forKey: "resend_code"), for: .normal)
        bCall.setTitle(doGetValueLanguage(forKey: "call_for_OTP"), for: .normal)
        bSendEmail.setTitle(doGetValueLanguage(forKey: "email_for_OTP"), for: .normal)
        bCancel.setTitle(doGetValueLanguage(forKey: "cancel").uppercased(), for: .normal)
        bVerify.setTitle(doGetValueLanguage(forKey: "verify").uppercased(), for: .normal)
        
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 100
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
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
            //            heightButtonResend.constant = 30
            
            if is_email_otp {
                bSendEmail.isHidden = false
                svResendMailAndCall.isHidden = false
            } else{
                bSendEmail.isHidden = true
            }
            
            if is_voice_otp {
                bCall.isHidden = false
                svResendMailAndCall.isHidden = false
            } else{
                bCall.isHidden = true
            }
            
            if is_email_otp &&  is_voice_otp{
                lbORSecond.isHidden = false
            }else {
                lbORSecond.isHidden = true
            }

        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            
            // 10. when the user enters something in the first textField it will automatically adjust to the next textField and in the process do some disabling and enabling. This will proceed until the last textField
            if (text.count < 1) && (string.count > 0) {
                
                if textField == txtOTPBox[0] {
                    txtOTPBox[0].isUserInteractionEnabled = false
                    txtOTPBox[1].isUserInteractionEnabled = true
                    _ = txtOTPBox[1].becomeFirstResponder()
                }
                
                if textField == txtOTPBox[1] {
                    txtOTPBox[1].isUserInteractionEnabled = false
                    txtOTPBox[2].isUserInteractionEnabled = true
                    _ = txtOTPBox[2].becomeFirstResponder()
                }
                
                if textField == txtOTPBox[2] {
                    txtOTPBox[2].isUserInteractionEnabled = false
                    txtOTPBox[3].isUserInteractionEnabled = true
                    _ = txtOTPBox[3].becomeFirstResponder()
                }
                if textField == txtOTPBox[3] {
                    txtOTPBox[3].isUserInteractionEnabled = false
                    txtOTPBox[4].isUserInteractionEnabled = true
                    _ = txtOTPBox[4].becomeFirstResponder()
                }
                
                if textField == txtOTPBox[4] {
                    txtOTPBox[4].isUserInteractionEnabled = false
                    txtOTPBox[5].isUserInteractionEnabled = true
                    _ = txtOTPBox[5].becomeFirstResponder()
                }
                
                if textField == txtOTPBox[5] {
                    //
                    print("call api")
                    //checkAllFilled()
                    Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.callApi), userInfo: nil, repeats: false)
                    _ = txtOTPBox[5].resignFirstResponder()
                }
                
                textField.text = string
                return false
                
            } // 11. if the user gets to the last textField and presses the back button everything above will get reversed
            else if (text.count >= 1) && (string.count == 0) {
                
                if textField == txtOTPBox[1] {
                    txtOTPBox[1].isUserInteractionEnabled = false
                    txtOTPBox[0].isUserInteractionEnabled = true
                    _ = txtOTPBox[0].becomeFirstResponder()
                    txtOTPBox[0].text = ""
                }
                
                
                if textField == txtOTPBox[2] {
                    txtOTPBox[2].isUserInteractionEnabled = false
                    txtOTPBox[1].isUserInteractionEnabled = true
                    _ = txtOTPBox[1].becomeFirstResponder()
                    txtOTPBox[1].text = ""
                }
                
                if textField == txtOTPBox[3] {
                    txtOTPBox[3].isUserInteractionEnabled = false
                    txtOTPBox[2].isUserInteractionEnabled = true
                    _ = txtOTPBox[2].becomeFirstResponder()
                    txtOTPBox[2].text = ""
                }
                
                if textField == txtOTPBox[4] {
                    txtOTPBox[4].isUserInteractionEnabled = false
                    txtOTPBox[3].isUserInteractionEnabled = true
                    _ = txtOTPBox[3].becomeFirstResponder()
                    txtOTPBox[3].text = ""
                }
                if textField == txtOTPBox[5] {
//                    txtOTPBox[5].isUserInteractionEnabled = false
//                    txtOTPBox[4].isUserInteractionEnabled = true
//                    txtOTPBox[4].becomeFirstResponder()
                    txtOTPBox[5].text = ""
                }
                
                
                if textField == txtOTPBox[0] {
                    // do nothing
                }
                
                textField.text = ""
                return false
                
            } // 12. after pressing the backButton and moving forward again you will have to do what's in step 10 all over again
            else if text.count >= 1 {
                
                if textField == txtOTPBox[0] {
                    txtOTPBox[0].isUserInteractionEnabled = false
                    txtOTPBox[1].isUserInteractionEnabled = true
                    _ =  txtOTPBox[1].becomeFirstResponder()
                }
                
                
                if textField == txtOTPBox[1] {
                    txtOTPBox[1].isUserInteractionEnabled = false
                    txtOTPBox[2].isUserInteractionEnabled = true
                    _ =  txtOTPBox[2].becomeFirstResponder()
                }
                if textField == txtOTPBox[2] {
                    txtOTPBox[2].isUserInteractionEnabled = false
                    txtOTPBox[3].isUserInteractionEnabled = true
                    _ = txtOTPBox[3].becomeFirstResponder()
                }
                if textField == txtOTPBox[3] {
                    txtOTPBox[3].isUserInteractionEnabled = false
                    txtOTPBox[4].isUserInteractionEnabled = true
                    _ = txtOTPBox[4].becomeFirstResponder()
                }
                if textField == txtOTPBox[4] {
                    txtOTPBox[4].isUserInteractionEnabled = false
                    txtOTPBox[5].isUserInteractionEnabled = true
                    _ = txtOTPBox[5].becomeFirstResponder()
                }
                
                
                
                
                if textField == txtOTPBox[5] {
                    // do nothing or better yet do something now that you have all four digits for the sms code. Once the user lands on this textField then the sms code is complete
                  //  checkAllFilled()
                    _ =  txtOTPBox[5].resignFirstResponder()
                    
                }
                
                textField.text = string
                return false
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
    @IBAction func textEditDidBegin(_ sender: ACFloatingTextfield) {
        activeTextField = sender as? CustomACFTextfield
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 100
        }
    }

    func userInputCombineString()->String{
        var string = ""
        for field in txtOTPBox{
            string.append(field.text!)

        }
        return string
    }

    @IBAction func onClickVerify(_ sender: Any) {

        otp = userInputCombineString()
        if otp == "" ||  otp.count < 6 {
            showAlertMessage(title: "", msg: "Enter valid OTP")
        } else {
            doCallLogin()
        }
    }
    
    @IBAction func onClickResend(_ sender: UIButton) {
        
       // doSendOtp()
        
        doSendOtp(otpType:String(sender.tag))
    }
  func  doUnbleSend()
  {
    self.count = 30
    viewResendOtp.isHidden = true
  }
    func doUnbleRsend() {
        self.count = 30
        viewResendOtp.isHidden = true
    
    }
    @IBAction func onClickClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func doSendOtp(otpType : String! = "0") {
        
        let IsFirebase = UserDefaults.standard.bool(forKey: StringConstants.KEY_IS_FIREBASE)
        print(IsFirebase)
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        //"user_token":UserDefaults.standard.string(forKey: StringConstants.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "user_login_new":"user_login_new",
                      "user_mobile":mobile!,
                      "society_id":society_id!,
                      "country_code":self.countrycode,
                      "otp_type":otpType!,
                      "is_firebase":"\(IsFirebase)"]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        requrest.requestPost(serviceName: ServiceNameConstants.otp_controller, parameters: params,baseUer: societyDetails.sub_domain! + StringConstants.APINEW) { (json, error) in
        
       // requrest.requestPost(serviceName: ServiceNameConstants.otp_controller, parameters: params) { (json, error) in
            
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
    
    func doLoadSliderData() {
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getSlider":"getSlider",
                      "society_id":doGetLocalDataUser().societyID!]
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPostCommon(serviceName: ServiceNameConstants.SLIDER_CONTROLLER, parameters: params) { (json, error) in
            //  self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(SliderResponse.self, from:json!)
                    if response.status == "200" {
                        if let encoded = try? JSONEncoder().encode(response) {
                            UserDefaults.standard.set(encoded, forKey: StringConstants.SLIDER_DATA)
                        }
                    }else {
                        
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    func  doCallLogin() {
        
        let IsFirebase = UserDefaults.standard.bool(forKey: StringConstants.KEY_IS_FIREBASE)
       
        
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        //"user_token":UserDefaults.standard.string(forKey: StringConstants.KEY_DEVICE_TOKEN)
        let params = ["key":societyDetails.api_key!,
                      "user_verify_new_country":"user_verify_new_country",
                      "society_id":societyDetails.society_id!,
                      "user_mobile":mobile!,
                      "user_token": UserDefaults.standard.string(forKey: StringConstants.KEY_DEVICE_TOKEN)!,
                      "device":"ios",
                      "otp":otp,
                      "is_firebase":"\(IsFirebase)",
                      "country_code":doGetLocalDataUser().countryCode!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        requrest.requestPost(serviceName: ServiceNameConstants.otp_controller, parameters: params,baseUer: societyDetails.sub_domain! + StringConstants.APINEW) { (json, error) in
            self.hideProgress()
            if json != nil {
               
               // print(json as Any)
                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from:json!)
                    if loginResponse.status == "200" {

                        if let encoded = try? JSONEncoder().encode(loginResponse) {
                            UserDefaults.standard.set(encoded, forKey: StringConstants.KEY_LOGIN_DATA)
                        }
                        UserDefaults.standard.set(loginResponse.baseURL, forKey: StringConstants.KEY_BASE_URL)
                        UserDefaults.standard.set(loginResponse.apiKey, forKey: StringConstants.KEY_API_KEY)
                        UserDefaults.standard.data(forKey: StringConstants.SLIDER_DATA)
                        UserDefaults.standard.set(loginResponse.userProfilePic,forKey: StringConstants.KEY_PROFILE_PIC)

                        let data = UserDefaults.standard.data(forKey: StringConstants.MULTI_SOCIETY_DETAIL)
                        if data != nil{
                            var decoded = try JSONDecoder().decode(SocietyArray.self, from: data!)
                           // print(decoded.SocietyDetails[0].society_name)
                           // print(decoded.SocietyDetails[0].societyID)
                            decoded.SocietyDetails.append(loginResponse)
                            print(decoded.SocietyDetails.count)
                            if let encoded = try? JSONEncoder().encode(decoded) {
                                UserDefaults.standard.set(encoded, forKey: StringConstants.MULTI_SOCIETY_DETAIL)
                            
                            }
                        }
                        self.dismiss(animated: true) {
                            Utils.setHome()
                            
//                            for controller in self.context.navigationController!.viewControllers as Array {
//                                if controller.isKind(of: SWRevealViewController.self) {
//                                    self.context.navigationController!.popToViewController(controller, animated: true)
//                                    break
//                                }else{
//                                    print("no Match")
//
//
//                                }
//                            }
                        }
                        
                       
                    }else {
                        
                        self.showAlertMessage(title: "Alert", msg: loginResponse.message)
                    }
                } catch {
                    print("parse error")
                }
            }
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
}
extension AddBuildingDialogOtpVC: ACFloatingTextfieldDeleteActionDelegate {
    func textFieldDidSelectDeleteButton(_ textField: ACFloatingTextfield) {
        if activeTextField == txtOTPBox[0] {
            print("backButton was pressed in txtOTPBox[0]")
            // do nothing
        }
        
        if activeTextField == txtOTPBox[1] {
            print("backButton was pressed in txtOTPBox[1]")
            txtOTPBox[1].isUserInteractionEnabled = false
            txtOTPBox[0].isUserInteractionEnabled = true
            _ = txtOTPBox[1].becomeFirstResponder()
            txtOTPBox[0].text = ""
        }
        
        
        if activeTextField == txtOTPBox[2] {
            print("backButton was pressed in txtOTPBox[2]")
            txtOTPBox[2].isUserInteractionEnabled = false
            txtOTPBox[1].isUserInteractionEnabled = true
            _ =  txtOTPBox[2].becomeFirstResponder()
            txtOTPBox[1].text = ""
        }
        
        
        if activeTextField == txtOTPBox[3] {
            print("backButton was pressed in txtOTPBox[3]")
            txtOTPBox[3].isUserInteractionEnabled = false
            txtOTPBox[2].isUserInteractionEnabled = true
            _ =  txtOTPBox[3].becomeFirstResponder()
            txtOTPBox[2].text = ""
        }
        
        
        if activeTextField == txtOTPBox[4] {
            print("backButton was pressed in txtOTPBox[4]")
            txtOTPBox[4].isUserInteractionEnabled = false
            txtOTPBox[3].isUserInteractionEnabled = true
            _ =  txtOTPBox[4].becomeFirstResponder()
            txtOTPBox[3].text = ""
        }
        
        if activeTextField == txtOTPBox[5] {
            print("backButton was pressed in txtOTPBox[5]")
            if txtOTPBox[5].text != "" {
                txtOTPBox[5].text = ""
                return
            }else {
                txtOTPBox[5].isUserInteractionEnabled = false
                txtOTPBox[4].isUserInteractionEnabled = true
                _ =  txtOTPBox[5].resignFirstResponder()
                txtOTPBox[4].text = ""
            }
            
            
        }
    }
}
