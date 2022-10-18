//
//  Utils.swift
//  Finca
//
//  Created by anjali on 01/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import Alamofire
import CommonCrypto
import CryptoSwift
import DeviceKit
class Utils: NSObject {

  static  func aesEncrypt(key: String, iv: String, message: String) throws -> String{
        let data = message.data(using: .utf8)!
        // let enc = try AES(key: key, iv: iv, padding: .pkcs5).encrypt([UInt8](data))
        let enc = try AES(key: Array(key.utf8), blockMode: CBC(iv: Array(iv.utf8)), padding: .pkcs5).encrypt([UInt8](data))
        let encryptedData = Data(enc)
        return encryptedData.base64EncodedString()
    }

   static func aesDecrypt(key: String, iv: String, message: String) throws -> String {
        let data = NSData(base64Encoded: message, options: NSData.Base64DecodingOptions(rawValue: 0))
        let dec = try AES(key: key, iv: iv, padding: .pkcs5).decrypt([UInt8](data!))
        let decryptedData = Data(dec)
        return String(bytes: decryptedData.bytes, encoding: .utf8) ?? "Could not decrypt"
    }

//    func encryptStringToBaseSixtyFour(value : String) -> String {
//          let data = value.data(using: .utf8)
//        return (data?.base64EncodedString())!
//    }
  // AES Encrypted String

//   func aesEncrypt(value: String, key: String, iv: String) throws -> String {
//       let data = value.data(using: .utf8)!
//    let encrypted = try! AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).encrypt([UInt8](data))
//       let encryptedData = Data(encrypted)
//       return encryptedData.base64EncodedString()
//   }
  // AES Decrypted Value

//   func aesDecrypt(encryptedString: String,key: String, iv: String) throws -> String {
//       let data = Data(base64Encoded: encryptedString)!
//       let decrypted = try! AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).decrypt([UInt8](data))
//       let decryptedData = Data(decrypted)
//       return String(bytes: decryptedData.bytes, encoding: .utf8) ?? "Could not decrypt"
//   }

    static func setRoundImageWithBorder(imageView:UIImageView , color:UIColor){
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        imageView.layer.borderColor = color.cgColor
        imageView.layer.borderWidth = 2
    }

    static func setImageFromUrl(imageView:UIImageView , urlString:String) {
        // print("utils kf string : ==== "+urlString)
        let url = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        //        imageView.kf.indicatorType = .activity
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)

        imageView.kf.setImage(
            with: URL(string: url!),
            placeholder: UIImage(named: "placeholder"),
            options: [ .processor(processor),
                       .scaleFactor(UIScreen.main.scale),
                       .transition(.fade(1)),
                       .cacheOriginalImage])
        {
            result in
            switch result {
            case .success( _):
                // print("Task done for: \(value.source.url?.absoluteString ?? "")")
                
                break
            case .failure(_):
                //                print("Job failed: \(error.localizedDescription)")
                
                break
            }
        }
    }
    static func setImageFromUrl(imageView:UIImageView , urlString:String ,palceHolder:String) {
        // print("utils kf string : ==== "+urlString)
        let url = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        //        imageView.kf.indicatorType = .activity
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)

        imageView.kf.setImage(
            with: URL(string: url!),
            placeholder: UIImage(named: palceHolder),
            options: [ .processor(processor),
                       .scaleFactor(UIScreen.main.scale),
                       .transition(.fade(1)),
                       .cacheOriginalImage])
        {
            result in
            switch result {
            case .success( _):
                // print("Task done for: \(value.source.url?.absoluteString ?? "")")
                break
            case .failure(_):
                //                print("Job failed: \(error.localizedDescription)")
                break
            }
        }
    }
    
  
    
    static func setHomeRootLogin() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let gotoDashboardVC = storyBoard.instantiateViewController(withIdentifier: "idLoginVC") as! LoginVC
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let nav : UINavigationController = UINavigationController()
        nav.viewControllers  = [gotoDashboardVC]
        nav.isNavigationBarHidden = true
        appdelegate.viewC = gotoDashboardVC
        appdelegate.window!.rootViewController = nav
        
    }

    static func setHome() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let gotoDashboardVC = storyBoard.instantiateViewController(withIdentifier: StringConstants.HOME_NAV_CONTROLLER) as! SWRevealViewController
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let nav : UINavigationController = UINavigationController()
        nav.viewControllers  = [gotoDashboardVC]
        nav.isNavigationBarHidden = true
        appdelegate.viewC = gotoDashboardVC
        appdelegate.window!.rootViewController = nav
        
    }
    
    static func setRoundImage(imageView:UIImageView ){
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        
    }
    
    static func setSplashVCRoot() {
        //Do changes here for logout view
        let splashVC = storyboardConstants.main.instantiateViewController(withIdentifier: "idSplashVC") as! SplashVC
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let nav : UINavigationController = UINavigationController()
        nav.viewControllers  = [splashVC]
        nav.isNavigationBarHidden = true
        appdelegate.viewC = splashVC
        appdelegate.window!.rootViewController = nav
    }
    
    static func setHomeRootLocation() {
        //      let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "idNavLocation")as! UINavigationController
       // let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //   let gotoDashboardVC = storyBoard.instantiateViewController(withIdentifier: "idLoginVC") as! LoginVC
       // let gotoDashboardVC = storyBoard.instantiateViewController(withIdentifier: "idSelectLocationVC") as! SelectLocationVC
        let gotoDashboardVC = SelectLanguageVC()
        gotoDashboardVC.setContryData(city_id: "0", state_id: "0", country_id: "101", country_code: "")
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let nav : UINavigationController = UINavigationController()
        nav.viewControllers  = [gotoDashboardVC]
        nav.isNavigationBarHidden = true
        appdelegate.viewC = gotoDashboardVC
        appdelegate.window!.rootViewController = nav
        
    }
    static func setRootTimeline() {
         let storyBoard : UIStoryboard = UIStoryboard(name: "sub", bundle: nil)
               let gotoDashboardVC = storyBoard.instantiateViewController(withIdentifier: "idTimelineVC") as! TimelineVC
               let appdelegate = UIApplication.shared.delegate as! AppDelegate
               let nav : UINavigationController = UINavigationController()
               nav.viewControllers  = [gotoDashboardVC]
               nav.isNavigationBarHidden = true
               appdelegate.viewC = gotoDashboardVC
               appdelegate.window!.rootViewController = nav
        
    }
    static func setRootSocietyList() {
         let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
               let gotoDashboardVC = storyBoard.instantiateViewController(withIdentifier: "idSocietyVC") as! SocietyVC
               let appdelegate = UIApplication.shared.delegate as! AppDelegate
               let nav : UINavigationController = UINavigationController()
               nav.viewControllers  = [gotoDashboardVC]
               nav.isNavigationBarHidden = true
               appdelegate.viewC = gotoDashboardVC
               appdelegate.window!.rootViewController = nav
        
    }
    ///Method updates all the local data (Call this method when changes are made to the profile data)
    static func updateLocalUserData(){
        DispatchQueue.main.async {
            Utils.doCallMultiUnitApi()
        }
        
    }
    static func doCallMultiUnitApi(){
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let device = Device.current
        let params = ["getMultiUnitsNew":"getMultiUnitsNew",
                      "user_mobile":BaseVC().doGetLocalDataUser().userMobile!,
                      "user_id":BaseVC().doGetLocalDataUser().userID!,
                      "society_id":BaseVC().doGetLocalDataUser().societyID!,
                      "user_token": UserDefaults.standard.string(forKey: StringConstants.KEY_DEVICE_TOKEN)!,
                      "app_version_code" : appVersion!,
                      "phone_brand":"Apple",
                      "device":"ios",
                      "phone_model":device.description,
                      "country_code":BaseVC().doGetLocalDataUser().countryCode ?? ""]
        
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
    
    static func userId() -> String {
        if UserDefaults.standard.data(forKey: StringConstants.KEY_LOGIN_DATA) != nil {
            return BaseVC().doGetLocalDataUser().userID ?? ""
        }
        return ""
    }
    static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    static func hexStringToUIColor (hex:String) -> UIColor {
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: CGFloat(1.0))
    }
    static func convertToimg(with view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
    }
    
    static func getChatMemberModel(chatData :  ChatFCMData) -> MemberListModel? {
//        var model  : MemberListModel?
//        model?.userID = chatData.userId ?? ""
//        model?.chatCount = chatData.unread_count ?? ""
//        model?.userFirstName = chatData.group_name ?? ""
//        model?.chatID = chatData.group_id ?? ""
//        model?.userProfilePic = chatData.group_icon ?? ""
//        model?.memberSize = chatData.member_count ?? ""
        return MemberListModel(altMobile: "", unitName: "", userID: chatData.userId ?? "", chatCount: chatData.unread_count ?? "", unitStatus: "", floorID: "", userLastName: "", unitID: "", userFullName: "", memberSize: chatData.member_count ?? "", userMobile: "", userType: "", blockName: "", floorName: "", memberStatus: "", userFirstName: chatData.group_name ?? "", chatID: chatData.group_id ?? "", flag: "", userStatus: "", userProfilePic: chatData.group_icon ?? "", publicMobile: "", memberDateOfBirth: "", indexPath: nil, joinStatus: false, blockStatus: false, msg_data: "", msg_date: "", customDate: nil, gender: "", selectMember: false, token: "", user_designation: "", company_name: "")
    }
}
