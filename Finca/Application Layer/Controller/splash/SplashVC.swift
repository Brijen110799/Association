//
//  SplashVC.swift
//  Finca
//
//  Created by anjali on 13/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import LocalAuthentication
import EzPopup
import FittedSheets

struct CheckVersionResspon : Codable{
    let versionApp: String!
    let advertisementUrl: String!
    let viewStatus: String!
    let backBanner: String!
    let versionCode: String!
    let status: String!
    let activeStatus: String!
    let versionId: String!
    let versionName: String!
    let message: String!
    let chatVideo : String!
    let timelineVideo : String!
    let languageVersion : String!
    let versionnameview : String!
    let appurl : String!
    let appname : String!
    let share_app_content : String!
    
    enum CodingKeys: String, CodingKey {
        case timelineVideo = "timeline_video"
        case chatVideo = "chat_video"
        case versionApp = "version_app"
        case advertisementUrl = "advertisement_url"
        case viewStatus = "view_status"
        case backBanner = "back_banner"
        case versionCode = "version_code"
        case status = "status"
        case activeStatus = "active_status"
        case versionId = "version_id"
        case versionName = "version_name"
        case message = "message"
        case languageVersion = "language_version"
        case versionnameview = "version_name_view"
        case appurl = "app_url"
        case appname = "app_name"
        case share_app_content
    }
}

class SplashVC: BaseVC {
    
    @IBOutlet weak var progressBar: NVActivityIndicatorView!
    @IBOutlet weak var ivLogo: UIImageView!
//    var resultNew = formatter.string(from: date)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressBar.color = UIColor.white
        progressBar.startAnimating()
        if UserDefaults.standard.bool(forKey: StringConstants.SECURITY_BIOMETRICS_FLAG){
            authenticationWithTouchID()
        }else{
           
            self.checkVersion()
        }
        //print(UserDefaults.standard.string(forKey: StringConstants.KEY_LOGIN))
        doSetNotificationCounterOnAppIcon(count:"0")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func callback() {
        
        if !isKeyPresentInUserDefaults(key: StringConstants.KEY_LOGIN) {
            // let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "idLoginVC")as! LoginVC
            let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "idNavLocation")as! UINavigationController
            loginVc.modalPresentationStyle = .fullScreen
            self.present(loginVc, animated: true, completion: nil)
            
        } else {
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: StringConstants.HOME_NAV_CONTROLLER)as! SWRevealViewController
            homeVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(homeVC, animated: true)
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

                    }else {

                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
    func checkVersion() {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        var result = formatter.string(from: date)
        let Newdate = String()
        UserDefaults.standard.setValue(Newdate, forKey: "date")
        UserDefaults.standard.synchronize()

    if result != Newdate
    {
        var appVersionFloat: Float = 0.0
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        appVersionFloat =  Float(appVersion!)!
        
        let params = ["version_app":"1",
                      "getVersion":"getVersion",
                      "mobile_app":"2"]
        
//        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPostMain(serviceName: ServiceNameConstants.version_controller, parameters: params) { (json, error) in
            
            if json != nil {
                //  self.hideProgress()
                print(json as Any)
                do {
                    let response = try JSONDecoder().decode(CheckVersionResspon.self, from:json!)
                    if response.status == "200" {
                        
                        
                        
//                        UserDefaults.standard.set(response.timelineVideo,forKey: StringConstants.TIMELINE_VIDEO_ID)
//                        UserDefaults.standard.set(response.chatVideo,forKey: StringConstants.CHAT_VIDEO_ID)
                        
                        self.instanceLocal().setShareappcontent(setdata: response.share_app_content ?? "")
                        
                        UserDefaults.standard.set(response.backBanner, forKey: StringConstants.KEY_BACKGROUND_IMAGE)
                        let version = Float(response.versionCode!)!
                        
//                        print("local" ,appVersionInt )
//                        print("set" ,version )
                        if appVersionFloat >= version  {
                          
                            if !self.isKeyPresentInUserDefaults(key: StringConstants.KEY_LOGIN) {
                                
//                                if UserDefaults.standard.value(forKey: StringConstants.LANGUAGE_DATA) == nil {
//                                    let vc = SelectLanguageVC()
//                                    self.pushVC(vc: vc)
//                                } else{
//                                    let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "idNavLocation")as! UINavigationController
//                                    loginVc.modalPresentationStyle = .fullScreen
//                                    self.present(loginVc, animated: true, completion: nil)
//                                }
                                
//                                let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "idNavLocation")as! UINavigationController
//                                loginVc.modalPresentationStyle = .fullScreen
//                                self.present(loginVc, animated: true, completion: nil)
                              
                                
//                                let vc = SelectLanguageVC()
//                                vc.setContryData(city_id: "0", state_id: "0", country_id: "101", country_code: "")
//                                self.pushVC(vc: vc)
                                let vc  = self.mainStoryboard.instantiateViewController(withIdentifier: "idSocietyVC") as! SocietyVC
                                vc.isAddBuilding = false
                                vc.city_id = "0"
                                vc.state_id = "0"
                                vc.country_id = "101"
                              //  vc.languageDictionary = dictionary
                                vc.languageId = "1"
                                vc.country_code = ""
                                self.pushVC(vc: vc)
                                
                            } else {
                                // self.doCheckLogin()
                                // self.doCheckLogin()
                                Utils.updateLocalUserData()
//                                let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "idHomeNavController")as! SWRevealViewController
//                                homeVC.modalPresentationStyle = .fullScreen
//                                self.navigationController?.pushViewController(homeVC, animated: true)
                                
                                if self.instanceLocal().getCompleteProfile() {
                                    
                                    let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "idHomeNavController")as! SWRevealViewController
                                    homeVC.modalPresentationStyle = .fullScreen
                                    self.navigationController?.pushViewController(homeVC, animated: true)
                                } else {
                                    let vc = ProfileCompleteVC()
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                        } else {
                            // ........old code.......
                            
                           // self.showAlertMessageWithClick(title: "Update Available", msg: "A new version of Fincasys is available on app store please update the app to version V-\(response.versionCode!) to proceed.")
                            
                            self.ShowAppUpdateDailog(StrVesion: response.versionCode! , appName: response.appname ?? "",appUrl:  response.appurl ?? "" )
                        }
                    }else {
                        self.toast(message: response.message, type: .Faliure)
                    }
                } catch {
                    print("parse error",error as Any)
                }
            }else{
                
                if !self.isKeyPresentInUserDefaults(key: StringConstants.KEY_LOGIN) {
                    
                    self.showNoInternetToast()
                    
                    
                } else {
                    
                    if self.instanceLocal().getCompleteProfile() {
                        
                        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "idHomeNavController")as! SWRevealViewController
                        homeVC.modalPresentationStyle = .fullScreen
                        self.navigationController?.pushViewController(homeVC, animated: true)
                    } else {
                        let vc = ProfileCompleteVC()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                }
                
                print("error",error as Any)
            }
        }
        }else
        {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            result = formatter.string(from: date)
            UserDefaults.standard.setValue(result, forKey: "date")
            UserDefaults.standard.synchronize()
            
        }
    }
    func ShowAppUpdateDailog(StrVesion : String , appName : String , appUrl : String) {
        
        let screenwidth = UIScreen.main.bounds.width
                let screenheight = UIScreen.main.bounds.height
        
               // let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DialogAppUpdateVC") as! DialogAppUpdateVC
        
             //   nextVC.cabCompanyList = self.dailyCompanyList
              //  nextVC.contextDailyVisitor = self
        
        let nextVC = DialogAppUpdateVC()
        
        nextVC.StrVersion = StrVesion
        nextVC.appName = appName
        nextVC.appurl = appUrl
        let popupVC = PopupViewController(contentController: nextVC, popupWidth: screenwidth - 10
                                          , popupHeight: screenheight
        )
        
                popupVC.backgroundAlpha = 0.8
                popupVC.backgroundColor = .black
                popupVC.shadowEnabled = true
                popupVC.canTapOutsideToDismiss = false
                present(popupVC, animated: true)
        
    }
//    override func onClickDone() {
//
//        let urlStr = "https://apps.apple.com/in/app/fincasys/id1472966034"
//        if #available(iOS 10.0, *) {
//            UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
//
//        } else {
//            UIApplication.shared.openURL(URL(string: urlStr)!)
//        }
//    }
    func doCheckLogin() {
        print("doCheckLogin")
        
        // showProgress()
         let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        let params = ["key":apiKey(),
                      "check_login":"check_login",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "user_name":doGetLocalDataUser().userMobile!,
                      "user_password":"",
                      "user_token": UserDefaults.standard.string(forKey: StringConstants.KEY_DEVICE_TOKEN)!,
                      "app_version_code" : appVersion!]
        
        
        print("check login " , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        requrest.requestPost(serviceName: ServiceNameConstants.check_login_status, parameters: params) { (json, error) in
            
            if json != nil {
                //  self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    
                    if response.status == "200" {
                        
                        //   let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "idRevealViewController")as! UINavigationController
                        //      self.present(homeVC, animated: true, completion: nil)
                        Utils.updateLocalUserData()
                       
                        
                        
                        if self.instanceLocal().getCompleteProfile() {
                            let vc = ProfileCompleteVC()
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "idHomeNavController")as! SWRevealViewController
                            homeVC.modalPresentationStyle = .fullScreen
                            self.navigationController?.pushViewController(homeVC, animated: true)
                        }
                    }else {
                        //  self.showAlertMessage(title: "Alert", msg: response.message)
                        //self.toast(message: response.message, type: .Faliure)
                        let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "idNavLocation")as! UINavigationController
                        loginVc.modalPresentationStyle = .fullScreen
                        self.present(loginVc, animated: true, completion: nil)
                    }
                } catch {
                    print("parse error",error as Any)
                }
            }
        }
    }
}
extension SplashVC {

    func authenticationWithTouchID() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"

        var authError: NSError?
        let reasonString = "To access the secure data"

        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {

            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reasonString) { success, evaluateError in

                if success {
                   
                    self.checkVersion()
                    //TODO: User authenticated successfully, take appropriate action

                } else {
                    //TODO: User did not authenticate successfully, look at error and take appropriate action
                    guard let error = evaluateError else {
                        return
                    }

                    print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))

                    //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully

                }
            }
        } else {

            guard let error = authError else {
                return
            }
            //TODO: Show appropriate alert if biometry/TouchID/FaceID is lockout or not enrolled
            print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))
        }
    }

    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
                case LAError.biometryNotAvailable.rawValue:
                    message = "Authentication could not start because the device does not support biometric authentication."

                case LAError.biometryLockout.rawValue:
                    message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."

                case LAError.biometryNotEnrolled.rawValue:
                    message = "Authentication could not start because the user has not enrolled in biometric authentication."

                default:
                    message = "Did not find error code on LAError object"
            }
        } else {
            switch errorCode {
                case LAError.touchIDLockout.rawValue:
                    message = "Too many failed attempts."

                case LAError.touchIDNotAvailable.rawValue:
                    message = "TouchID is not available on the device"

                case LAError.touchIDNotEnrolled.rawValue:
                    message = "TouchID is not enrolled on the device"

                default:
                    message = "Did not find error code on LAError object"
            }
        }

        return message;
    }

    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {

        var message = ""

        switch errorCode {

        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"

        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"

        case LAError.invalidContext.rawValue:
            message = "The context is invalid"

        case LAError.notInteractive.rawValue:
            message = "Not interactive"

        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"

        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"

        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            exit(0)

        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"

        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }

        return message
    }
}
