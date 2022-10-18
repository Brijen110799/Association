//
//  AddBuildingLoginVC.swift
//  Finca
//
//  Created by harsh panchal on 02/01/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import EzPopup
class AddBuildingLoginVC: BaseVC {
    @IBOutlet weak var LoginButtonParentVie: UIView!
    var countryList = CountryList()
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var ivLogo: UIImageView!
    @IBOutlet weak var ivPassword: UIImageView!
    @IBOutlet weak var tfMobile: UITextField!
    @IBOutlet weak var tfPassword: ACFloatingTextfield!
    @IBOutlet weak var lblCountryNameCode: UILabel!
    @IBOutlet weak var heightPasswordView: NSLayoutConstraint!
    @IBOutlet weak var viewPassword: UIView!
    var phoneCode = "+91"
    @IBOutlet weak var bForgot: UIButton!
    @IBOutlet weak var lbNameSocity: UILabel!
    @IBOutlet weak var lbWelcome: UILabel!
    @IBOutlet weak var lbSelectSoceity: UILabel!
    @IBOutlet weak var lbDontAcc: UILabel!
    @IBOutlet weak var lblSignUp: UILabel!
    
  
    @IBOutlet weak var bContinue: UIButton!
    
    var society_id:String!
    var society_name:String!
    var iconClick = true
    var city_id : String! // = ""
    var state_id : String! // = ""
    var country_id : String! // = ""
    var countryName = "India"
    var countryCode = ""
    var societyDetails : ModelSociety!
    var gradient : CAGradientLayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        countryList.delegate = self
        // Do any additional setup after loading the view.
        //lbNameSocity.text = "Welcome to " + society_name.capitalizingFirstLetter()
        doneButtonOnKeyboard(textField: tfMobile)
        tfMobile.delegate = self
        //tfMobile.tec
       // lblCountryNameCode.text = "\u{1F1EE}\u{1F1F3} +91"
        setDefultCountry()
        hideKeyBoardHideOutSideTouch()
        lblSignUp.textColor = ColorConstant.colorP
        
        bContinue.setTitle(doGetValueLanguageForAddMore(forKey: "Continue").uppercased(), for: .normal)
        tfMobile.placeholder = doGetValueLanguageForAddMore(forKey: "enter_your_mobile_number")
        lbSelectSoceity.text = doGetValueLanguageForAddMore(forKey: "select_other_society")
        lbDontAcc.text = doGetValueLanguageForAddMore(forKey: "don_t_have_an_account")
        lblSignUp.text = doGetValueLanguageForAddMore(forKey: "register_now")
        lbNameSocity.text = "\(doGetValueLanguageForAddMore(forKey: "welcome_to")) \(society_name.capitalizingFirstLetter())"
       // lblCountryNameCode.text = countryCode
    }
    func setDefultCountry(){
        let localRegion =  Locale.current.regionCode
        let count = Countries()
        for item in count.countries {
            if item.countryCode == localRegion{
                lblCountryNameCode.text = "+\(item.phoneExtension)"
                self.countryName = item.name!
                self.countryCode = item.countryCode
                self.phoneCode =  "+\(item.phoneExtension)"
                break
            }
        }
    }
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    override func viewWillAppear(_ animated: Bool) {
      //  UIApplication.shared.isStatusBarHidden = true
        viewBack.layer.maskedCorners = [.layerMinXMinYCorner]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //It will show the status bar again after dismiss
        //UIApplication.shared.isStatusBarHidden = false
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
    
    @IBAction func btnSelectCountry(_ sender: Any) {
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    
    @IBAction func onClickLogin(_ sender: Any) {
        
        if validate() {
            // doLogin()
            doSendOtp()
        }
    }
    
    @IBAction func onClickBAck(_ sender: Any) {
        doPopBAck()
    }
    
    @IBAction func onClickPasswordShow(_ sender: Any) {
        
        if(iconClick == true) {
            tfPassword.isSecureTextEntry = false
            ivPassword.image = UIImage(named: "visibility_black")
            ivPassword.setImageColor(color: UIColor.white)
            
        } else {
            tfPassword.isSecureTextEntry = true
            ivPassword.image = UIImage(named: "visibility_off")
            ivPassword.setImageColor(color: UIColor.white)
            
        }
        
        iconClick = !iconClick
    }
    
    @IBAction func onClickRegister(_ sender: Any) {
        
        ///  let vc = storyboard?.instantiateViewController(withIdentifier: "idSocietyVC") as! SocietyVC
        /// self.navigationController?.pushViewController(vc, animated: true)
        
//        let vc  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idSelectUserTypeVC") as! SelectUserTypeVC
//        vc.society_id = society_id
//        vc.societyDetails = self.societyDetails
//        vc.isAddMoreSociety = true
//        self.navigationController?.pushViewController(vc, animated: true)
        
//        let vc  = storyboard?.mainStory().instantiateViewController(withIdentifier: "idSelectBlockAndRoomVC") as! SelectBlockAndRoomVC
//        vc.society_id = society_id
//        vc.userType = "0"
//        vc.isUserInsert = true
//        vc.isAddMoreSociety = true
//        vc.societyDetails = societyDetails
//        vc.country_code = phoneCode
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let vc  = NewRegistrationVC()
        vc.society_id = self.society_id
        vc.block_id = ""
        vc.block_name = ""
        vc.country_code = phoneCode
        vc.isUserInsert = true
        vc.societyDetails = societyDetails
        self.navigationController?.pushViewController(vc, animated: true)
  
    }
    @IBAction func onClickForgot(_ sender: Any) {
        if tfMobile.text!.count > 9 {
            doForgotPassword()
        } else {
          //  tfMobile.errorMessage = "Enter Registered Mobile Number"
            showAlertMessage(title: "", msg: doGetValueLanguageForAddMore(forKey:  "please_enter_valid_mobile_number"))
        }
    }
    func doForgotPassword() {
        
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":societyDetails.api_key!,
                      "user_login":"user_login",
                      "user_mobile":tfMobile.text!,
                      "society_id":society_id!,
                      "country_code":self.countryCode]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        requrest.requestPost(serviceName: ServiceNameConstants.forgotPassword, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    
                    
                    if response.status == "200" {
                        self.showAlertMessage(title: "", msg: response.message)
                    }else {
                        //                        UserDefaults.standard.set("0", forKey: StringConstants.KEY_LOGIN)
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    @IBAction func btnSelectOtherBuilding(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func onClickTerms(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idTermsAndConditionVC") as! TermsAndConditionVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func validate() -> Bool {
        var validate = true
        print("validate")
//        if (tfMobile.text!.count < 8){
//            tfMobile.errorMessage = "Enter Registered Mobile Number"
//            validate = false
//        }
        if (tfMobile.text?.isEmptyOrWhitespace())! || tfMobile.text!.count < 8 {
            showAlertMessage(title: "", msg: doGetValueLanguageForAddMore(forKey: "please_enter_valid_mobile_number"))
            validate = false
        }
        
        /*  if (tfPassword.text == "" ){
         showAlertMessage(title: "", msg: "You need to enter a  Password")
         validate = false
         }*/
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
    
    private func showOtpDailog(is_email_otp : Bool , is_voice_otp : Bool) {
        let screenwidth = UIScreen.main.bounds.width
               let screenheight = UIScreen.main.bounds.height
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idAddBuildingDialogOtpVC") as! AddBuildingDialogOtpVC
        vc.mobile = tfMobile.text!
        vc.society_id = society_id
        vc.country_id  = country_id
        vc.state_id  = state_id
        vc.city_id  = city_id
        vc.countrycode = self.phoneCode
        vc.countryName = self.countryName
        vc.societyDetails = self.societyDetails
        vc.context = self
        vc.is_email_otp = is_email_otp
        vc.is_voice_otp = is_voice_otp
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth-10  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }
    
  private  func doSendOtp() {
        showProgress()
        
        let IsFirebase = UserDefaults.standard.bool(forKey: StringConstants.KEY_IS_FIREBASE)
        print(IsFirebase)
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        //"user_token":UserDefaults.standard.string(forKey: StringConstants.KEY_DEVICE_TOKEN)
        let params = ["key":societyDetails.api_key!,
                      "user_login_new":"user_login_new",
                      "user_mobile":tfMobile.text!,
                      "society_id":self.society_id!,
                      "country_code":self.phoneCode,
                      "is_firebase":"\(IsFirebase)",
                      "otp_type":"0"]
                      
 
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        requrest.requestPost(serviceName: ServiceNameConstants.otp_controller, parameters: params,baseUer: societyDetails.sub_domain! + StringConstants.APINEW) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let loginResponse = try JSONDecoder().decode(OTPResponse.self, from:json!)
                    
                    
                    if loginResponse.status == "200" {
                        self.showOtpDailog(is_email_otp: loginResponse.is_email_otp ?? false, is_voice_otp: loginResponse.is_voice_otp ?? false)
                    }else {
                        //                        UserDefaults.standard.set("0", forKey: StringConstants.KEY_LOGIN)
                        self.showAlertMessage(title: "Alert", msg: loginResponse.message ?? "")
                    }
                } catch {
                    print("parse error")
                }
            }else{
                self.hideProgress()
                print(error as Any)
                print(json as Any)
            }
        }
    }
    
    @IBAction func btnBackPressedd(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension AddBuildingLoginVC : CountryListDelegate {
    func selectedCountry(country: Country) {
        lblCountryNameCode.text = "+\(country.phoneExtension)"

        self.countryName = country.name!
        self.countryCode = country.countryCode
        self.phoneCode = "+\(country.phoneExtension)"
    }
}
