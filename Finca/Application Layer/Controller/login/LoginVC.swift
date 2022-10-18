//
//  LoginVC.swift
//  Finca
//
//  Created by anjali on 24/05/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import EzPopup

class LoginVC: BaseVC {
    @IBOutlet weak var btnCheckMark:UIButton!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var lblTermsAndCondition: UILabel!
    @IBOutlet weak var lblSignUp: UILabel!
    @IBOutlet weak var LoginButtonParentVie: UIView!
    @IBOutlet weak var ivLogo: UIImageView!
    @IBOutlet weak var tfMobile: UITextField!
    @IBOutlet weak var lblCountryNameCode: UILabel!
    @IBOutlet weak var lbNameSocity: UILabel!
    @IBOutlet weak var imgvwCheckMark:UIImageView!
    
    @IBOutlet weak var lbWelcome: UILabel!
    @IBOutlet weak var lbSelectSoceity: UILabel!
    @IBOutlet weak var lbDontAcc: UILabel!
    @IBOutlet weak var lbByContinue: UILabel!
    @IBOutlet weak var bContinue: UIButton!
    
    @IBOutlet weak var lbAssPhoneNum: UILabel!
    @IBOutlet weak var lbAssocMail: UILabel!
    @IBOutlet weak var lbAssWeb: UILabel!
    
    @IBOutlet weak var  viewAssPhone : UIView!
    @IBOutlet weak var  viewAssMail : UIView!
    @IBOutlet weak var  viewAssWeb : UIView!

    @IBOutlet weak var  scrollview : UIScrollView!

    
    private let request = AlamofireSingleTon.sharedInstance
    var countryList = CountryList()
    var society_id:String!
    var society_name:String!
    var iconClick = true
    var city_id : String! // = ""
    var state_id : String! // = ""
    var country_id : String! // = ""
    var countryName = "India"
    var countryCode = "Ind"
   // var phoneCode = ""
    var societyDetails : ModelSociety!
    var gradient : CAGradientLayer!
    var FlagCheckmark = false
     var country_code = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryList.delegate = self
        doneButtonOnKeyboard(textField: tfMobile)
        addKeyboardAccessory(textFields: [tfMobile])

        
        tfMobile.delegate = self
        hideKeyBoardHideOutSideTouch()
        imgvwCheckMark.image = UIImage(named: "check_box_uncheck")
        imgvwCheckMark.setImageColor(color: ColorConstant.primaryColor)
        setDefultCountry()
        
        bContinue.setTitle(doGetValueLanguage(forKey: "Continue").uppercased(), for: .normal)
        tfMobile.placeholder = doGetValueLanguage(forKey: "enter_your_mobile_number")
        lbSelectSoceity.text = doGetValueLanguage(forKey: "select_other_society")
        lbDontAcc.text = doGetValueLanguage(forKey: "don_t_have_an_account")
        lblSignUp.text = doGetValueLanguage(forKey: "register_now")
        lblSignUp.textColor = ColorConstant.colorP
        lbByContinue.text = doGetValueLanguage(forKey: "i_agree_to_fincasys")
        lblTermsAndCondition.text = doGetValueLanguage(forKey: "terms_conditions_privacy")
        lbNameSocity.text = "\(doGetValueLanguage(forKey: "welcome_to")) \(String(describing: society_name!))"
        lblCountryNameCode.text = country_code
        
//        lbAssPhoneNum.text = societyDetails.association_phone_number ?? ""
//        lbAssocMail.text = societyDetails.association_email ?? ""
//        lbAssWeb.text = societyDetails.association_website ?? ""
        
        self.setUnderLineText(label: lbAssPhoneNum, text: societyDetails.association_phone_number ?? "")
        self.setUnderLineText(label: lbAssocMail, text: societyDetails.association_email ?? "")
        self.setUnderLineText(label: lbAssWeb, text: societyDetails.association_website ?? "")


        viewAssPhone.isHidden = true
        if let phoneNo = societyDetails.association_phone_number {
            if phoneNo != "" {
                viewAssPhone.isHidden = false
            }
        }
        
        viewAssMail.isHidden = true
        if let phoneNo = societyDetails.association_email {
            if phoneNo != "" {
                viewAssMail.isHidden = false
            }
        }

        viewAssWeb.isHidden = true
        if let phoneNo = societyDetails.association_website {
            if phoneNo != "" {
                viewAssWeb.isHidden = false
            }
        }


        //doCheckLanguageModify()
        btnCheckMark.isSelected = true
        imgvwCheckMark.image = UIImage(named: "check_box")
        imgvwCheckMark.setImageColor(color: ColorConstant.primaryColor)
        lblTermsAndCondition.textColor = ColorConstant.primaryColor
        tfMobile.keyboardType = .numberPad
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
   
    }
    
    func setUnderLineText(label: UILabel, text: String?) {
        
        guard let text = text else { return }
        let attributedText = NSMutableAttributedString(string: text, attributes: [.foregroundColor: ColorConstant.primaryColor, .font: UIFont(name: Static.sharedInstance.zoobiz_font_regular, size: 13.0)!, .underlineStyle: NSUnderlineStyle.single.rawValue])
        label.attributedText = attributedText
        
    }
    
    
    func setDefultCountry(){
        let localRegion =  Locale.current.regionCode
        let count = Countries()
        for item in count.countries {
            if item.countryCode == localRegion{
                lblCountryNameCode.text = "\(item.flag!) (\(item.countryCode)) +\(item.phoneExtension)"
                self.countryName = item.name!
                self.countryCode = item.countryCode
                self.country_code =  "+\(item.phoneExtension)"
                break
            }
        }
    }
    @IBAction func btnSelectOtherSociety(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
       // UIApplication.shared.isStatusBarHidden = true
         viewBack.layer.maskedCorners = [.layerMinXMinYCorner]
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //It will show the status bar again after dismiss
     //   UIApplication.shared.isStatusBarHidden = false
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    
     @objc func keyboardWillShow(notification: NSNotification) {
         let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
         let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
         
         self.scrollview.contentInset = contentInsets
         self.scrollview.scrollIndicatorInsets = contentInsets
         
         var aRect : CGRect = self.view.frame
         aRect.size.height -= keyboardSize.height
     }
    
     @objc func keyboardWillHide(notification: NSNotification) {
         let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
         self.scrollview.contentInset = contentInsets
         self.scrollview.scrollIndicatorInsets = contentInsets
     }
    
    func addGradient(viewMain:UIView!,color:[CGColor]){
        gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint.zero, size: viewMain.bounds.size)
        gradient.colors = color
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = viewMain.bounds.height/2
        viewMain.layer.insertSublayer(gradient, at: 0)
    }
    @IBAction func ClickCheckMark(_ sender: UIButton) {
        sender.isSelected = !(sender.isSelected)
        print(sender.isSelected)
        
        if sender.isSelected == true
        {
            imgvwCheckMark.image = UIImage(named: "check_box")
            imgvwCheckMark.setImageColor(color: ColorConstant.primaryColor)
        }else
        {
            imgvwCheckMark.image = UIImage(named: "check_box_uncheck")
            imgvwCheckMark.setImageColor(color: ColorConstant.primaryColor)
        }
    }
    @IBAction func btnSelectCountry(_ sender: Any) {
           let navController = UINavigationController(rootViewController: countryList)
           self.present(navController, animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    @IBAction func onClickLogin(_ sender: Any) {
        if validate() {
            doSendOtp()
        }
    }
    @IBAction func onClickBAck(_ sender: Any) {
        doPopBAck()
    }
//    @IBAction func onClickPasswordShow(_ sender: Any) {
//
//        if(iconClick == true) {
//            tfPassword.isSecureTextEntry = false
//            ivPassword.image = UIImage(named: "visibility_black")
//            ivPassword.setImageColor(color: UIColor.white)
//
//        } else {
//            tfPassword.isSecureTextEntry = true
//            ivPassword.image = UIImage(named: "visibility_off")
//            ivPassword.setImageColor(color: UIColor.white)
//
//        }
//        iconClick = !iconClick
//    }
    @IBAction func onClickRegister(_ sender: Any) {
        
        ///  let vc = storyboard?.instantiateViewController(withIdentifier: "idSocietyVC") as! SocietyVC
        /// self.navigationController?.pushViewController(vc, animated: true)
        
//        let vc  = storyboard?.instantiateViewController(withIdentifier: "idSelectUserTypeVC") as! SelectUserTypeVC
//        vc.society_id = society_id
//        vc.societyDetails = self.societyDetails
//        self.navigationController?.pushViewController(vc, animated: true)
        
       /* let vc  = storyboard?.instantiateViewController(withIdentifier: "idSelectBlockAndRoomVC") as! SelectBlockAndRoomVC
        vc.society_id = self.society_id
        vc.societyDetails = societyDetails
        //    vc.unitModel = unitModel
        vc.userType = "0"
        // vc.isUserInsert = false
        vc.isAddMoreSociety = false
        vc.country_code = country_code
        //   vc.ownedDataSelectVC = self
        self.view.endEditing(true)
        self.navigationController?.pushViewController(vc, animated: true)*/
        let vc  = NewRegistrationVC()
        vc.society_id = self.society_id
        vc.block_id = ""
        vc.block_name = ""
        vc.country_code = country_code
        vc.isUserInsert = true
        vc.societyDetails = societyDetails
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickForgot(_ sender: Any) {
        if tfMobile.text!.count > 9 {
            doForgotPassword()
        } else {
            //tfMobile.errorMessage = "Enter Registered Mobile Number"
            showAlertMessage(title: "", msg: "Enter Registered Mobile Number")
        }
    }
    
    @IBAction func onClickAssociationLinkActions(_ sender: UIButton) {
        
        if sender.tag == 1 {
            // phone link
            if let phoneNo = societyDetails.association_phone_number {
                if phoneNo != "" {
                    self.doCall(on: phoneNo)
                }
            }
        }
        else if sender.tag == 2 {
            // mail link
            if let mail = societyDetails.association_email {
                if mail != "" {
                    print(mail)
                    if let url = URL(string: "mailto:\(mail)") {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                }
            }
        }
        else {
            // web link
            if let web = societyDetails.association_website {
                if web != "" {
                    print(web)
                    if let url = URL(string: web) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
//                    guard let url = URL(string: web) else { return }
//                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    func doForgotPassword() {
        
        showProgress()
       // let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":societyDetails.api_key!,
                      "user_login":"user_login",
                      "user_mobile":tfMobile.text!,
                      "society_id": self.society_id!,
                      "country_code":self.countryCode]
        
        print("param" , params)
        
        
        
        request.requestPost(serviceName: ServiceNameConstants.forgotPassword, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    
                    if response.status == "200" {
                        self.showAlertMessage(title: "", msg: response.message)
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error",error as Any)
                    
                }
            }
        }
    }
    @IBAction func onClickTerms(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "idTermsAndConditionVC") as! TermsAndConditionVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func validate() -> Bool {
        var validate = true
        
//        print("validate")
       /* if (tfMobile.text == ""){
            tfMobile.errorMessage = "Enter Registered Mobile Number"
            validate = false
        }
        if tfMobile.text!.count < 8 {
            tfMobile.errorMessage = "Enter Valid Mobile Number"
            validate = false
        }else if !(btnCheckMark.isSelected) {
            showAlertMessage(title: "", msg: "Please accept Terms & Conditions.")
            validate = false
        }else
        {
            tfMobile.errorMessage = ""
        }*/
        
        if (tfMobile.text?.isEmptyOrWhitespace())! || tfMobile.text!.count < 8 {
            showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_valid_mobile_number"))
            validate = false
        }
        
        if !(btnCheckMark.isSelected) {
            showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_agree_to_are_user_policy_to_continue"))
            validate = false
        }
        
        
//        if !(btnCheckMark.isSelected) {
//                   showAlertMessage(title: "", msg: "Please accept Terms & Conditions.")
//               }
        return validate
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tfMobile {
            let maxLength = 15
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
    func showOtpDailog(isEmailOTP: Bool, isCallOTP: Bool) {
        
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idDailogOTPVC") as! DailogOTPVC
        vc.mobile = tfMobile.text!
        vc.society_id = society_id
        vc.country_id  = country_id
        vc.state_id  = state_id
        vc.city_id  = city_id
        vc.countrycode = self.country_code
        vc.countryName = self.countryName
        vc.context = self
        vc.is_email_otp = isEmailOTP
        vc.is_voice_otp  = isCallOTP
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth-10  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }
   private func doSendOtp() {
        showProgress()
        let IsFirebase = UserDefaults.standard.bool(forKey: StringConstants.KEY_IS_FIREBASE)
        print(IsFirebase)
    
        let params = ["key":societyDetails.api_key!,
                      "user_login_new":"user_login_new",
                      "user_mobile":tfMobile.text!,
                      "society_id":self.society_id!,
                      "country_code":self.country_code,
                      "is_firebase":"\(IsFirebase)",
                      "otp_type":"0"]

     //   print("param" , params)
     
        
        request.requestPost(serviceName: ServiceNameConstants.otp_controller, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let loginResponse = try JSONDecoder().decode(OTPResponse.self, from:json!)
                  
                    if loginResponse.status == "200" {
                        self.toast(message: loginResponse.message, type: .Success)
                        self.showOtpDailog(isEmailOTP: loginResponse.is_email_otp ?? false, isCallOTP: loginResponse.is_voice_otp ?? false)
                    }else {
                      
                        self.toast(message: loginResponse.message, type: .Faliure)
                    }
                } catch {
                    print("parse error",error as Any)
                }
            }
        }
    }
    
    private func doCheckLanguageModify() {
        
        let params = ["checkLangugeModify":"checkLangugeModify",
                      "society_id": self.society_id ?? ""]
        request.requestPostCommon(serviceName: NetworkAPI.language_controller, parameters: params) { (json, error) in
            
            if json != nil {
               
                do {
                    let response = try JSONDecoder().decode(ResponseLanguageModify.self, from:json!)
                    
                    if response.status == "200" {
                        
                        if response.is_language_re_downlaod ?? false {
                            // dowload new language data
                            self.doGetLanguageData()
                        }
                        
                       
                    }else {
                      // self.showAlertMessage(title: "Alert", msg: response.message ?? "")
                    }
                } catch {
                    print("parse error",error as Any)
                    
                }
            }
        }
        
        
    }
    
    func doGetLanguageData() {
        showProgress()
        let params = ["getLanguageValues":"getLanguageValues",
                      "language_id":doGetLanguageId(),
                      "society_id":self.society_id ?? ""]
       print("param" , params)
     
        request.doGetLanguageData(serviceName: NetworkAPI.language_controller, parameters: params) { (dictionary, error) in
            self.hideProgress()
            if dictionary != nil {
                let langKey = "\(StringConstants.LANGUAGE_ID)\(self.society_id ?? "0")"
                UserDefaults.standard.setValue(self.doGetLanguageId(), forKey: langKey)
             
                let dataKey = "\(StringConstants.LANGUAGE_DATA)\(self.society_id  ?? "0")"
                UserDefaults.standard.set(dictionary, forKey: dataKey)
        
            }
           
        }
    }
    
    
}
extension LoginVC : CountryListDelegate {
    func selectedCountry(country: Country) {
      //  lblCountryNameCode.text = "\(country.flag!) +\(country.phoneExtension)"
        //lblCountryNameCode.text = "\(country.flag!) (\(country.countryCode)) +\(country.phoneExtension)"
        self.countryName = country.name!
        self.countryCode = country.countryCode
        self.country_code = "+\(country.phoneExtension)"
        lblCountryNameCode.text = self.country_code
        UserDefaults.standard.setValue(self.country_code, forKey: "CountryCode")
        UserDefaults.standard.synchronize()
    }
    func selectedAltCountry(country: Country) {
       
    }
}

struct ResponseLanguageModify : Codable{
    var  is_language_re_downlaod : Bool? //": true,
    var  message : String? //": "Success",
    var  status : String? //": "200"
}
struct OTPResponse : Codable{
    let trx_id : String? //" : "667503395",
    let is_email_otp : Bool? //" : true,
    let status : String? //" : "200",
    let is_voice_otp : Bool? //" : true,
    let message : String? //" : "OTP Send Successfully"
    
}
