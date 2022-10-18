//
//  DailogOTPVC.swift
//  Finca
//
//  Created by anjali on 30/09/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class CustomACFTextfield: ACFloatingTextfield {
   override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
   }
}

class DailogOTPVC: BaseVC {
    
    @IBOutlet weak var tfNumberOne: UITextField!
    @IBOutlet weak var tfNumberTwo: UITextField!
    @IBOutlet weak var tfNumberThree: UITextField!
    @IBOutlet weak var tfNumberFour: UITextField!
    
    @IBOutlet weak var lbNumber: UILabel!
    @IBOutlet weak var lbCount: UILabel!
    
    @IBOutlet weak var viewResendOtp: UIStackView!
    @IBOutlet weak var bResend: UIButton!
    @IBOutlet var txtOTPBox: [CustomACFTextfield]!
    
    @IBOutlet weak var lbCountryCode: UILabel!
    
    @IBOutlet weak var lbOtpVerification: UILabel!
    @IBOutlet weak var lbEnterOtp: UILabel!
   // @IBOutlet weak var lbOR: UILabel!
    @IBOutlet weak var lbORSecond: UILabel!
   
    @IBOutlet weak var bSendEmail: UIButton!
    @IBOutlet weak var bCall: UIButton!
    
    @IBOutlet weak var bCancel: UIButton!
    @IBOutlet weak var bVerify: UIButton!
    @IBOutlet weak var svResendMailAndCall: UIStackView!
 
    var mobile:String!
    var isShowVoiceCallOTP = false
    var isShowEmailOTP = false
    var society_id:String!
    
    var country_id : String!
    var state_id : String!
    var city_id : String!
    var context : LoginVC!
    var count = 0
    var otp = ""
    var countrycode = ""
    var countryName = ""
    var isHeightUp = true
    var activeTextField :  CustomACFTextfield!
    var is_email_otp  = true
    var is_voice_otp  = true
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        txtOTPBox[0].addTarget(self, action: #selector(self.textFieldDidChangeOne(_:)), for: .editingChanged)
        
        for index in 0...5 {
//            print(num)
            txtOTPBox[index].textAlignment = .center
            doneButtonOnKeyboard(textField: txtOTPBox[index])
            txtOTPBox[index].delegate = self
            txtOTPBox[index].deleteDelegate = self
            txtOTPBox[index].isUserInteractionEnabled = false
        }
        
        _ = txtOTPBox[0].becomeFirstResponder()
        txtOTPBox[0].isUserInteractionEnabled = true
        
        doUnbleSend()
        lbCountryCode.text = "\(countrycode)"
        if #available(iOS 12.0, *) {
            txtOTPBox[0].textContentType = .oneTimeCode
        }
        
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
//        checkAllFilled()
//        if textField == txtOTPBox[5] {
//            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.callApi), userInfo: nil, repeats: false)
//        }
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
    
    @IBAction func textEditChanged(_ sender: ACFloatingTextfield) {
        
    }
    
    
    
//    @objc func textFieldDidChange(textField : UITextField)  {
//        let text = textField.text
//        if text?.utf16.count == 1 {
//            switch textField {
//            case txtOTPBox[0]:
//                txtOTPBox[1].becomeFirstResponder()
//
//            case txtOTPBox[1]:
//                txtOTPBox[2].becomeFirstResponder()
//
//            case txtOTPBox[2]:
//                txtOTPBox[3].becomeFirstResponder()
//
//            case txtOTPBox[3]:
//                txtOTPBox[4].resignFirstResponder()
//
//            case txtOTPBox[4]:
//                txtOTPBox[5].resignFirstResponder()
//
//            case txtOTPBox[5]:
//                txtOTPBox[5].resignFirstResponder()
//
//            default:
//                break
//            }
//        } else {
//            switch textField {
//
//            case txtOTPBox[5]:
//                txtOTPBox[4].becomeFirstResponder()
//
//            case txtOTPBox[4]:
//                txtOTPBox[3].becomeFirstResponder()
//
//            case txtOTPBox[3]:
//                txtOTPBox[2].becomeFirstResponder()
//
//            case txtOTPBox[2]:
//                txtOTPBox[1].becomeFirstResponder()
//
//            case txtOTPBox[1]:
//                txtOTPBox[0].becomeFirstResponder()
//
//            case txtOTPBox[0]:
//                txtOTPBox[0].resignFirstResponder()
//
//            default:
//                break
//            }
//        }
//    }
    
    
    
    func checkAllFilled() {
        
//        if (tfPin1.text?.isEmpty)! || (tfPin2.text?.isEmpty)! || (tfPin3.text?.isEmpty)! || (tfPin4.text?.isEmpty)! {
        
        if (txtOTPBox[0].text?.isEmpty)! || (txtOTPBox[1].text?.isEmpty)! || (txtOTPBox[2].text?.isEmpty)! || (txtOTPBox[3].text?.isEmpty)! || (txtOTPBox[4].text?.isEmpty)! || (txtOTPBox[5].text?.isEmpty)! {
            
            //  buttonUnSelected()
        }else {
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.callApi), userInfo: nil, repeats: false)
            
            //            otp = tfPin1.text! + tfPin2.text! + tfPin3.text! + tfPin4.text!
            //            doSendOtp()
            //            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func userInputCombineString()->String{
        var string = ""
        for field in txtOTPBox{
            string.append(field.text!)
            
        }
        return string
    }
        
    @objc func callApi() {
        otp = userInputCombineString()
        if otp == "" ||  otp.count < 6 {
            showAlertMessage(title: "", msg: "Enter valid OTP")
        } else {
            doCallLogin()
        }
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
        doSendOtp(otpType:String(sender.tag))
    }
    
    func doUnbleRsend() {
        self.count = 30
        viewResendOtp.isHidden = true
//        heightButtonResend.constant = 0
    }
    
    func doUnbleSend() {
        self.count = 30
        viewResendOtp.isHidden = true
//        heightButtonResend.constant = 0
        
    }
    
    @IBAction func onClickClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func doSendOtp(otpType : String! = "0") {
        let IsFirebase = UserDefaults.standard.bool(forKey: StringConstants.KEY_IS_FIREBASE)
        showProgress()
       
        let params = ["key":apiKey(),
                      "user_login_new":"user_login_new",
                      "user_mobile":mobile!,
                      "society_id":society_id!,
                      "otp_type":otpType!,
                      "is_firebase":"\(IsFirebase)",
                      "country_code":self.countrycode]
        // print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        requrest.requestPost(serviceName: ServiceNameConstants.otp_controller, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
               //  print(json as Any)
                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from:json!)
                // print(loginResponse.countryId ?? "")
                    UserDefaults.standard.setValue(loginResponse.countryId, forKey: "countryid")
                    UserDefaults.standard.synchronize()
                    
                    if loginResponse.status == "200" {
                        self.doUnbleRsend()
                    } else {
                        // UserDefaults.standard.set("0", forKey: StringConstants.KEY_LOGIN)
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
        request.requestPostCommon(serviceName: ServiceNameConstants.SLIDER_CONTROLLER, parameters: params) {(json, error) in
            //  self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(SliderResponse.self, from:json!)
                    if response.status == "200" {
                        if let encoded = try? JSONEncoder().encode(response) {
                            UserDefaults.standard.set(encoded, forKey: StringConstants.SLIDER_DATA)
                        }
                        self.doLoadSliderData()
                    }else {
                        
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    func doCallLogin() {
        
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        //"user_token":UserDefaults.standard.string(forKey: StringConstants.KEY_DEVICE_TOKEN)
        
        let IsFirebase = UserDefaults.standard.bool(forKey: StringConstants.KEY_IS_FIREBASE)
        //  print(IsFirebase)
        
        let params = ["key": apiKey(),
                      "user_verify_new_country":"user_verify_new_country",
                      "society_id":society_id!,
                      "user_mobile":mobile!,
                      "user_token": UserDefaults.standard.string(forKey: StringConstants.KEY_DEVICE_TOKEN)!,
                      "device":"ios",
                      "otp":otp,
                      "is_firebase":"\(IsFirebase)",
                      "country_code":countrycode]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.otp_controller, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                print(json as Any)
                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from:json!)
                    
                    
                    if loginResponse.status == "200" {
                        UserDefaults.standard.set(loginResponse.countryId, forKey:"countryid")
                        UserDefaults.standard.synchronize()
                        
                        //  UserDefaults.standard.set(self.tfMobile.text!, forKey: StringConstants.KEY_USER_NAME)
                        
                        UserDefaults.standard.set(loginResponse.userProfilePic, forKey: StringConstants.KEY_PROFILE_PIC)
                        
                        //                        self.doLoadSliderData()
                        
                        
                        let multiSociety = SocietyArray(SocietyDetails: [loginResponse])
                        if let encoded = try? JSONEncoder().encode(multiSociety) {
                            UserDefaults.standard.set(encoded, forKey: StringConstants.MULTI_SOCIETY_DETAIL)
                        }
                        
                        if let encoded = try? JSONEncoder().encode(loginResponse) {
                            UserDefaults.standard.set(encoded, forKey: StringConstants.KEY_LOGIN_DATA)
                        }
                        UserDefaults.standard.set(loginResponse.visitorApproved, forKey: StringConstants.VISITOR_APPROVAL_FLAG)
                        UserDefaults.standard.set(self.country_id, forKey: StringConstants.COUNTRYID)
                        UserDefaults.standard.set(self.state_id, forKey: StringConstants.STATEID)
                        UserDefaults.standard.set(self.city_id, forKey: StringConstants.CITYID)
                        UserDefaults.standard.set("1", forKey: StringConstants.KEY_LOGIN)
                        
                        self.dismiss(animated: true) {
                            if loginResponse.get_business_data ?? false && loginResponse.memberStatus ?? "" ==
                                "0" {
                                self.instanceLocal().setCompleteProfile(setData: false)
                                let vc = ProfileCompleteVC()
                                self.context.navigationController?.pushViewController(vc, animated: true)
                            } else {
                                
                                self.instanceLocal().setCompleteProfile(setData: true)
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: StringConstants.HOME_NAV_CONTROLLER) as! SWRevealViewController
                                self.context.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
//                        self.navigationController?.pushViewController(vc, animated: true)
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
}

extension DailogOTPVC: ACFloatingTextfieldDeleteActionDelegate {
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


