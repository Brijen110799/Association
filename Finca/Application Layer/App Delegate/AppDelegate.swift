//
//  AppDelegate.swift
//  Finca
//
//  Created by anjali on 24/05/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import GoogleMaps
import GooglePlaces
//import Fire
//import IQKeyboardManagerSwift
import EzPopup
import AVFoundation
import SwiftyJSON
import GooglePlaces
import GoogleMaps
import FirebaseFirestore

// MARK: - SurveyQuestionReponse
struct childSecurityNotificationData: Codable {
    var childPhoto: String!
    var childSecurityId: String!
    var title: String!
    var visitorName: String!

    enum CodingKeys: String, CodingKey {
        case childPhoto = "child_photo"
        case childSecurityId = "child_security_id"
        case title = "title"
        case visitorName = "visitor_name"
    }
}
struct FcmHouseiGameJoin : Codable {
    //let img_url : String!//": "Ajit Mauray Ajit Mauray(B-101)",
    let title : String!//": "https:\/\/www.fincasys.com\/img\/sos\/Fire_1566561460.png",
    //let description : String!//": "48",
    let society_id : String!//": "1",
 
}
struct FcmCustomNotify : Codable {
    let img_url : String!//": "Ajit Mauray Ajit Mauray(B-101)",
    let title : String!//": "https:\/\/www.fincasys.com\/img\/sos\/Fire_1566561460.png",
    let description : String!//": "48",
    let notification_time : String!//": "1",
 
}
struct FcmData : Codable {
    let sos_by : String!//": "Ajit Mauray Ajit Mauray(B-101)",
    let sos_image : String!//": "https:\/\/www.fincasys.com\/img\/sos\/Fire_1566561460.png",
    let society_id : String!//": "48",
    let sos_status : String!//": "1",
    let sos_for : String!//": "0",
    let sos_type : Int!//": "1",
    let time : String!//": "16:44:20",
    let sos_title : String!//": "Fire",
    let otime : String!//": "30-08-2019 16:44"
    let society_name:String!
}
struct ResponseVisitorFCM  : Codable{
    let  visitor_name : String!// : "Tedt",
    let  visitor_status : String!// : "0",
    let  visitor_mobile : String!// : "8975646577",
    let  status : String!// : "200",
    let  user_name : String!// : null,
    let  message : String!// : "Visitor Data Get Successfully",
    let  visit_time : String!// : "08 Oct 2020 01:20 PM",
    let  visitor_id : String!// : "70",
    let  visit_from : String!// : "",
    let  view_message : String!// : "",
    let  society_id : String!// : "75",
    let  visit_logo : String!// : "https:\/\com\/img\/visitor_company\/guestMini.png",
    let  visitor_type : String!// : "0",
    let  unit_name : String!// : "A-201",
    let  visitor_profile : String!// : "https:\/\/developermg\/visitor\/visitor_default.png"
  
}
@UIApplicationMain
	class AppDelegate: UIResponder, UIApplicationDelegate {
    var viewC :  UIViewController!
    var viewSw :  SWRevealViewController!
    var myOrientation: UIInterfaceOrientationMask = .portrait
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13.0, *) {
        }else{
            UIApplication.shared.statusBarView?.backgroundColor = UIColor(named: "ColorPrimary")
        }
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        let db = Firestore.firestore()
        print(db) // silence warning
        doFirebase(application: application)
        do {
            Network.reachability = try Reachability(hostname: "www.google.com")
            do {
                try Network.reachability?.start()
            } catch let error as Network.Error {
                print(error)
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }

        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback)
        } catch  {
            print("Audio session failed")
        }

        GMSPlacesClient.provideAPIKey(StringConstants.GOOGLE_MAP_KEY)   // AIzaSyALu7b7PhCAcpyes_1-ZDK4e2hrhC0cH1Q
        GMSServices.provideAPIKey(StringConstants.GOOGLE_MAP_KEY)
        
        return true
    }
    func  doFirebase(application : UIApplication) {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
    }
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return myOrientation
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    func applicationWillTerminate(_ application: UIApplication) {
       // UserDefaults.standard.set(false, forKey: StringConstants.HOME_BANNER_LOCALLY_VIEWED    )
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    // for fcm handle
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("ddd  didReceiveRemoteNotification: \(messageID)")
        }
        
//        let state = application.applicationState
//           switch state {
//
//           case .inactive:
//               print("Inactive")
//
//           case .background:
//               print("Background")
//               // update badge count here
//               application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1
//
//           case .active:
//               print("Active")
//
//           @unknown default:
//            break
//
//        }
//
       // application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1
        DispatchQueue.main.async {
            application.applicationIconBadgeNumber =  1
        }
             
        // Print full message.
        print(userInfo)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("ddd didReceiveRemoteNotification babk:  \(messageID)")
        }
        // Print full message.
        print(userInfo)
        let state = application.applicationState
        switch state {

        case .inactive:
            print("Inactive")
        case .background:
            print("Background")
            // update badge count here
            application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1

        case .active:
            print("Active")
            application.applicationIconBadgeNumber =  1

        @unknown default:
            break

        }
        //        DispatchQueue.main.async {
        //            application.applicationIconBadgeNumber =  1
        //        }

        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
  /*  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        Messaging.messaging().apnsToken = deviceToken
    }
    
    
        func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
            
            
            let sendingAppID = options[.sourceApplication]
            
            print("source application = \(sendingAppID ?? "Unknown")")
                
            print("teste = " , options)
            return true
        }*/
        
}
extension UNNotificationAttachment {
    convenience init(data: Data, options: [NSObject: AnyObject]?) throws {
        let fileManager = FileManager.default
        let temporaryFolderName = ProcessInfo.processInfo.globallyUniqueString
        let temporaryFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(temporaryFolderName, isDirectory: true)
 
        try fileManager.createDirectory(at: temporaryFolderURL, withIntermediateDirectories: true, attributes: nil)
        let imageFileIdentifier = UUID().uuidString + ".jpg"
        let fileURL = temporaryFolderURL.appendingPathComponent(imageFileIdentifier)
        try data.write(to: fileURL)
        try self.init(identifier: imageFileIdentifier, url: fileURL, options: options)
    }
}
extension UNNotificationRequest {
    var attachment: UNNotificationAttachment? {
        print("Notification Recived")
        guard let attachmentURL = content.userInfo["img_url"] as? String, let imageData = try? Data(contentsOf: URL(string: attachmentURL)!) else {
            return nil
        }
        print("IMAGE DATA - ", imageData)
        return try? UNNotificationAttachment(data: imageData, options: nil)
    }
}
// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        print(userInfo as Any)
        let pref = UserDefaults.init(suiteName: "group.id.gits.notifserviceextension")
        pref?.set(userInfo, forKey: "NOTIF_DATA")
        Messaging.messaging().appDidReceiveMessage(userInfo)

        guard let clickAction = userInfo["click_action"] as? String else {
                return
        }
        let bvc = BaseVC()
        let clickActionDict = bvc.convertToDictionary(text: clickAction)
        if clickActionDict != nil{
            if clickActionDict!["title"] != nil{
                if clickActionDict!["title"] as! String == "newChildApprove"{
                    NotificationCenter.default.post(name: .childApprovalRequest, object: nil, userInfo:clickActionDict)
                }
            }

            if clickActionDict![""] != nil{
                NotificationCenter.default.post(name: .chatMsgReceived, object: nil, userInfo: clickActionDict)
            }
        }

        if clickAction.lowercased() == "child"{
            NotificationCenter.default.post(name:.childSecurityRequestStatusChange, object: nil, userInfo: nil)
        }

        guard let menuClick = userInfo["menuClick"] as? String  else {
            return
        }

        if menuClick == "chatMsg"{
            NotificationCenter.default.post(name: .chatMsgReceived, object: nil, userInfo: userInfo)
        }
      
        if menuClick.lowercased() == "chatmsggroup"{
            NotificationCenter.default.post(name: .groupChatMsgReceived, object: nil, userInfo: userInfo)
            
            guard
                let aps =  userInfo["aps"] as? NSDictionary,
                let alert = aps["category"] as? String
            else {
                return
            }
            do{
                let datap = alert.data(using: .utf8)!
                let fcmData = try JSONDecoder().decode([ChatFCMData].self, from: datap)
                if fcmData[0].userId ?? "" == Utils.userId() {
                    completionHandler([])
                }
            }catch{
                print("parse error",error)
            }
            
            
        }
       
        guard
            let aps =  userInfo["aps"] as? NSDictionary,
            let alert = aps["category"] as? String
            else {
                return
        }
        if alert == "lostfound" {
            NotificationCenter.default.post(name:.LostAndFoundRefresh, object: nil)
        }
        if let messageID = userInfo[gcmMessageIDKey] {
            print("dd11 Message ID: \(messageID)")
        }
        if let body = userInfo["body"] {
            print("dd11 Message ID: \(body)")
        }
        
        if let society_id = userInfo["society_id"] {
            print("notification for society id ====== \(society_id)")
            var multiSocietyArray = [LoginResponse]()
            let data = UserDefaults.standard.data(forKey: StringConstants.MULTI_SOCIETY_DETAIL)
            if data != nil{
                let decoded = try? JSONDecoder().decode(SocietyArray.self, from: data!)
                multiSocietyArray.append(contentsOf: (decoded?.SocietyDetails)!)
            }
            
            for society in multiSocietyArray{
                if society.societyID == (society_id as! String){
                    UserDefaults.standard.set(society.baseURL, forKey: StringConstants.KEY_BASE_URL)
                    UserDefaults.standard.set(society.apiKey, forKey: StringConstants.KEY_API_KEY)
                    if let encoded = try? JSONEncoder().encode(society) {
                        UserDefaults.standard.set(encoded, forKey: StringConstants.KEY_LOGIN_DATA)
                        
                    }
                }
            }
        }
       
        if menuClick == "changeBaseURL" {
        
            UserDefaults.standard.set(clickAction, forKey: StringConstants.KEY_BASE_URL)
            var multiSocietyArray = [LoginResponse]()
            let data = UserDefaults.standard.data(forKey: StringConstants.MULTI_SOCIETY_DETAIL)
            if data != nil{
                let decoded = try? JSONDecoder().decode(SocietyArray.self, from: data!)
                multiSocietyArray.append(contentsOf: (decoded?.SocietyDetails)!)
            }
            var arrayTempsociety = [LoginResponse]()
            
            if let society_id = userInfo["society_id"] {
                
            for society in multiSocietyArray {
                
                if society.societyID == (society_id as! String) {
                    
                    var customSoc = society
                    customSoc.baseURL = clickAction
                    arrayTempsociety.append(customSoc)
                    
//                    arrayTempsociety.append(LoginResponse(userID: society.userID, societyID: society.societyID, userFullName: society.userFullName, userFirstName: society.userFirstName, userLastName: society.userLastName, userMobile: society.userMobile, userEmail: society.userEmail, userIDProof: society.userIDProof, userType: society.userType, blockID: society.blockID, blockName: society.blockName, floorName: society.floorName, unitName: society.unitName, baseURL: clickAction, floorID: society.floorID, unitID: society.unitID, unitStatus: society.unitStatus, userStatus: society.userStatus, memberStatus: society.memberStatus, publicMobile: society.publicMobile, memberDateOfBirth: society.memberDateOfBirth, memberDateOfBirthSet: society.memberDateOfBirthSet, facebook: society.facebook, instagram: society.instagram, linkedin: society.linkedin, altMobile: society.altMobile, userProfilePic: society.userProfilePic, ownerName: society.ownerName, ownerEmail: society.ownerEmail, ownerMobile: society.ownerMobile, societyAddress: society.societyAddress, societyLatitude: society.societyLatitude, societyLongitude: society.societyLongitude, member: society.member, emergency: society.emergency, message: society.message, status: society.status, society_name: society.society_name, sosAlert: society.sosAlert, visitorApproved: society.visitorApproved, tenantView: society.tenantView, cityName: society.cityName, apiKey: society.apiKey, currency: society.currency, gender: society.gender, isSociety: society.isSociety, labelSettingResident: society.labelSettingResident, labelSettingApartment: society.labelSettingApartment, accountDeactive: society.accountDeactive, countryId: society.countryId, stateId: society.stateId, cityId: society.cityId, countryCodeAlt: society.countryCodeAlt ?? "", countryCode: society.countryCode ?? "",company_name : society.company_name ?? "",get_business_data : society.get_business_data ?? true,designation : society.designation ?? "" ,profile_progress : society.profile_progress ?? "",employment_description : society.employment_description ?? "",company_address : society.company_address ?? "",company_contact_number : society.company_contact_number ?? "",business_categories_sub : society.business_categories_sub ?? "",professional_other : society.professional_other ?? "",plot_lattitude : society.plot_lattitude ?? "",plot_longitude : society.plot_longitude ?? "",search_keyword : society.search_keyword ?? "",company_website : society.company_website ?? "" ,logoutIosDevice: society.logoutIosDevice ?? false))
                
                    UserDefaults.standard.set(society.baseURL, forKey: StringConstants.KEY_BASE_URL)
                    UserDefaults.standard.set(society.apiKey, forKey: StringConstants.KEY_API_KEY)
                    if let encoded = try? JSONEncoder().encode(society) {
                        UserDefaults.standard.set(encoded, forKey: StringConstants.KEY_LOGIN_DATA)
                        
                    }
                } else {
            
                    arrayTempsociety.append(society)
                    
// arrayTempsociety.append(LoginResponse(userID: society.userID, societyID: society.societyID, userFullName: society.userFullName, userFirstName: society.userFirstName, userLastName: society.userLastName, userMobile: society.userMobile, userEmail: society.userEmail, userIDProof: society.userIDProof, userType: society.userType, blockID: society.blockID, blockName: society.blockName, floorName: society.floorName, unitName: society.unitName, baseURL: society.baseURL, floorID: society.floorID, unitID: society.unitID, unitStatus: society.unitStatus, userStatus: society.userStatus, memberStatus: society.memberStatus, publicMobile: society.publicMobile, memberDateOfBirth: society.memberDateOfBirth, memberDateOfBirthSet: society.memberDateOfBirthSet, facebook: society.facebook, instagram: society.instagram, linkedin: society.linkedin, altMobile: society.altMobile, userProfilePic: society.userProfilePic, ownerName: society.ownerName, ownerEmail: society.ownerEmail, ownerMobile: society.ownerMobile, societyAddress: society.societyAddress, societyLatitude: society.societyLatitude, societyLongitude: society.societyLongitude, member: society.member, emergency: society.emergency, message: society.message, status: society.status, society_name: society.society_name, sosAlert: society.sosAlert, visitorApproved: society.visitorApproved, tenantView: society.tenantView, cityName: society.cityName, apiKey: society.apiKey, currency: society.currency, gender: society.gender, isSociety: society.isSociety, labelSettingResident: society.labelSettingResident, labelSettingApartment: society.labelSettingApartment, accountDeactive: society.accountDeactive, countryId: society.countryId, stateId: society.stateId, cityId: society.cityId, countryCodeAlt: society.countryCodeAlt ?? "", countryCode: society.countryCode ?? "",company_name : society.company_name ??  "",get_business_data : society.get_business_data ?? true,designation : society.designation ?? "" , profile_progress : society.profile_progress ?? "",employment_description : society.employment_description ?? "",company_address : society.company_address ?? "",company_contact_number : society.company_contact_number ?? "",business_categories_sub : society.business_categories_sub ?? "",professional_other : society.professional_other ?? "",plot_lattitude : society.plot_lattitude ?? "",plot_longitude : society.plot_longitude ?? "",search_keyword : society.search_keyword ?? "",company_website : society.company_website ?? "",logoutIosDevice: society.logoutIosDevice ?? false))
                    
            
                }
            }
                let data = SocietyArray(SocietyDetails: arrayTempsociety)
                if let encoded = try? JSONEncoder().encode(data) {
                    UserDefaults.standard.set(encoded, forKey: StringConstants.MULTI_SOCIETY_DETAIL)
                    
                }
            }
        }
        
        if let title = userInfo["title"] as? String{
            
//            print("FCM MESSAGE TITLE: \(title)")
          let society_id =   userInfo["society_id"]
           
            if title.lowercased()  == "Logout".lowercased() {
//                print("logout called")
                
                if menuClick == "changeBaseURL"{
                    UserDefaults.standard.set(clickAction, forKey: StringConstants.KEY_BASE_URL)
                }
               
                let data = UserDefaults.standard.data(forKey: StringConstants.MULTI_SOCIETY_DETAIL)
                 var multiSocietyArray = [LoginResponse]()
                if data != nil{
                    let decoded = try? JSONDecoder().decode(SocietyArray.self, from: data!)
                    multiSocietyArray.append(contentsOf: (decoded?.SocietyDetails)!)
                }
                
                if multiSocietyArray.count > 1 {
                    for (index,item) in multiSocietyArray.enumerated() {
                        if item.societyID == (society_id as! String){
                            multiSocietyArray.remove(at: index)
                        }
                    }
                    
                    print("soci count   " , multiSocietyArray)
                    let multiSociety = SocietyArray(SocietyDetails: multiSocietyArray)
                    if let encoded = try? JSONEncoder().encode(multiSociety) {
                        UserDefaults.standard.set(encoded, forKey: StringConstants.MULTI_SOCIETY_DETAIL)
                    }
                    
                    UserDefaults.standard.set(multiSocietyArray[0].baseURL, forKey: StringConstants.KEY_BASE_URL)
                    UserDefaults.standard.set(multiSocietyArray[0].apiKey, forKey: StringConstants.KEY_API_KEY)
                    if let encoded = try? JSONEncoder().encode(multiSocietyArray[0]) {
                        UserDefaults.standard.set(encoded, forKey: StringConstants.KEY_LOGIN_DATA)
                    }
                    
                } else {
                    UserDefaults.standard.set(false, forKey: StringConstants.KEY_LOGIN)
//                    Utils.setHomeRootLocation()
                    Utils.setSplashVCRoot()
                    completionHandler([])
                }
            }
            
            if title  == "Pass Verified" {
                NotificationCenter.default.post(name: NSNotification.Name(StringConstants.UPDATE_PASS_LIST), object: nil, userInfo:nil)
            }
            
            if title  == "New Visitor Arrived" {
                
                 NotificationCenter.default.post(name: NSNotification.Name(StringConstants.VISITOR_ARRIVED), object: nil, userInfo:nil)
            }
            
            if title  == "sos" {
                
                print("this sos come")
                // handle data and open sos scree
                // here is handle custom data from fcm
                if let dict = notification.request.content.userInfo["aps"] as? [String : Any] {
                    
                    if let body = dict["category"] as? String {
                        let datap = body.data(using: .utf8)!
                        print("\n\n",datap,"\n\n")
                        do{
                            let fcmData = try JSONDecoder().decode(FcmData.self, from: datap)
                            
                            print("\n\n\n\n fcm data\n",fcmData,"\n\n\n\n")
                            let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let initialViewControlleripad = mainStoryboard.instantiateViewController(withIdentifier: "idSosAlertVC") as! SosAlertVC
                            initialViewControlleripad.fcmData = fcmData
                            self.window = UIWindow(frame: UIScreen.main.bounds)
                            self.window?.rootViewController = initialViewControlleripad
                            self.window?.makeKeyAndVisible()
                        }catch{
                            print("parse error",error)
                        }
                        
                    }
                }
                
            }
            
            if title == "Rule Claim" {
                completionHandler([])
            }
       
            if clickAction.lowercased() == "userclaim"{
                completionHandler([])
            }
            if menuClick.lowercased() == "HousieJoinGame".lowercased() {
                completionHandler([])
            }
            if title == "" {
                completionHandler([])
            }
            
        }

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: StringConstants.KEY_NOTIFIATION), object: nil,userInfo: userInfo)
        print(userInfo)
       
        completionHandler([.alert,.badge,.sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("dd Message ID: \(messageID)")
        }
       // response.notification.request.content.so
        print(userInfo as Any)
        
        guard
            let aps =  userInfo["aps"] as? NSDictionary,
            let alert = aps["category"] as? String
            else {
                return
        }
        if alert == "lostfound" {
            NotificationCenter.default.post(name:.LostAndFoundRefresh, object: nil)
        }
        
        if let title = userInfo["title"] as? String {
            print("dd Message ID: \(title)")
            
            if title.lowercased() == "Logout".lowercased() {
                UserDefaults.standard.set(nil, forKey: StringConstants.KEY_LOGIN)
//                 Utils.setHomeRootLocation()
                Utils.setSplashVCRoot()
                return
            }
            
            if title == "sos"{
                if let dict = response.notification.request.content.userInfo["aps"] as? [String : Any] {
                    
                    if let body = dict["category"] as? String {
                        let datap = body.data(using: .utf8)!
                        print("\n\n",datap,"\n\n")
                        do{
                            let fcmData = try JSONDecoder().decode(FcmData.self, from: datap)
                            
                            print("\n\n\n\n fcm data\n",fcmData,"\n\n\n\n")
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            if  let SosVC = storyboard.instantiateViewController(withIdentifier: "idSosAlertVC") as? SosAlertVC {
                                SosVC.fcmData = fcmData
                                self.window?.rootViewController = SosVC
                            }
                        }catch{
                            print("parse error",error)
                        }
                    }
                }
            }
         
         
            
            guard let menuClick = userInfo["menuClick"] as? String  else {
                return
            }
            UserDefaults.standard.setValue(menuClick, forKeyPath: StringConstants.KEY_MENU_CLICK_FOR)
            guard let click_action = userInfo["click_action"] as? String  else {
                return
            }
            if menuClick == "changeBaseURL"{
             
                UserDefaults.standard.set(click_action, forKey: StringConstants.KEY_BASE_URL)
            }
            if menuClick.lowercased() == "DiscussionVC".lowercased(){
                UserDefaults.standard.set(click_action, forKey: StringConstants.KEY_CLICK_ACTION)
                if  let vc = storyboardConstants.discussion.instantiateViewController(withIdentifier: "idDiscussionListVC") as? DiscussionListVC {
                    let rootNC = UINavigationController(rootViewController: vc)
                    rootNC.isNavigationBarHidden = true
                    self.window?.rootViewController = rootNC
                    return
                }
            }
            
            if menuClick == "timeline" {
                let storyboard = UIStoryboard(name: "sub", bundle: nil)
                if  let vc = storyboard.instantiateViewController(withIdentifier: "idNotificationTimeLineVC") as? NotificationTimeLineVC {
                    vc.feed_id = click_action
                    vc.isComeFromAppDelegate = "0"
                    let rootNC = UINavigationController(rootViewController: vc)
                    rootNC.isNavigationBarHidden = true
                    self.window?.rootViewController = rootNC
                    return
                }
            }
                     
            if menuClick == "custom_notification" {
                
                if let dict = response.notification.request.content.userInfo["aps"] as? [String : Any] {
                    
                    if let body = dict["category"] as? String {
                        let datap = body.data(using: .utf8)!
                        print("\n\n",datap,"\n\n")
                        do{
                            let fcmData = try JSONDecoder().decode(FcmCustomNotify.self, from: datap)
                            
                            print("\n\n\n\n fcm data\n",fcmData,"\n\n\n\n")
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            if  let VC = storyboard.instantiateViewController(withIdentifier: "CustomNotificationShowVC") as? CustomNotificationShowVC {
                                VC.CustomNotify = fcmData
                                VC.IsComeFromCustomNotify = "1"
                                self.window?.rootViewController = VC
                                return
                            }
                        }catch{
                            print("parse error",error)
                        }
                    }
                }
            }
            
            if menuClick == "HousieJoinGame" {
                let storyboard = UIStoryboard(name: "Entertaiment", bundle: nil)
                if  let VC = storyboard.instantiateViewController(withIdentifier: "idHousiInfoVC") as? HousiInfoVC {
                    VC.IsComeFromAppdelegate = "1"
                    self.window?.rootViewController = VC
                    return
                }
            }
            
            if menuClick.lowercased() == "chatMsg".lowercased(){
                if let dict = response.notification.request.content.userInfo["aps"] as? [String : Any] {
                    
                    if let body = dict["category"] as? String {
                        let datap = body.data(using: .utf8)!
                       // print("\n\n",datap,"\n\n")
                        do{
                            let fcmData = try JSONDecoder().decode([ChatFCMData].self, from: datap)
                            let storyboard = UIStoryboard(name: "Chat", bundle: nil)
                            if  let vc = storyboard.instantiateViewController(withIdentifier: "idChatVC") as? ChatVC {
                                vc.user_id = fcmData[0].userId ?? ""
                                vc.userFullName = fcmData[0].userName ?? ""
                                vc.user_image = fcmData[0].userProfile ?? ""
                                vc.public_mobile  =  fcmData[0].publicMobile ?? "0"
                                vc.mobileNumber =  fcmData[0].recidentMobile ?? ""
                                vc.isGateKeeper = false
                                vc.isComeFcm = "chat"
                                let navget = UINavigationController(rootViewController: vc)
                                navget.navigationBar.isHidden = true
                                self.window?.rootViewController = navget
                                return
                            }
                        }catch{
                            print("parse error",error)
                        }
                    }
                }
            }
            
            if menuClick.lowercased() == "chatMsgGroup".lowercased(){
                if let dict = response.notification.request.content.userInfo["aps"] as? [String : Any] {
                    
                    if let body = dict["category"] as? String {
                        let datap = body.data(using: .utf8)!
                       // print("\n\n",datap,"\n\n")
                        do{
                            let fcmData = try JSONDecoder().decode([ChatFCMData].self, from: datap)
                            let storyboard = UIStoryboard(name: "Chat", bundle: nil)
                            if  let vc = storyboard.instantiateViewController(withIdentifier: "idGroupChatVC") as? GroupChatVC {
                                vc.group_details = Utils.getChatMemberModel(chatData: fcmData[0])
                                vc.isComeFcm = "1"
                                let navget = UINavigationController(rootViewController: vc)
                                navget.navigationBar.isHidden = true
                                self.window?.rootViewController = navget
                                return
                            }
                        }catch{
                            print("parse error",error)
                        }
                    }
                }
            }
            
        }
        Utils.setHome()
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: StringConstants.KEY_NOTIFIATION), object: nil)
       
        print(userInfo)
        completionHandler()
    }
}

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        UserDefaults.standard.set(fcmToken, forKey: StringConstants.KEY_DEVICE_TOKEN)
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        print("Received data message: \(remoteMessage.appData)")
//    }
    // [END ios_10_data_message]
    
    
}

struct ChatFCMData : Codable {
    // for chat
    let block_name:String?
    let sentTo:String?
    let publicMobile:String?
    let from:String?
    let userType:String?
    let recidentMobile:String?
    let userName:String?
    let userId:String?
    let userProfile:String?
    
    //for group
    let unread_count : String? //":"1",
    let group_id : String? //":"1",
    let group_name : String? //":"Silverwingteam",
    let group_icon : String? //":"https:\/\/dev.myassociation.app\/img\/users\/",
    let member_count : String? //":"27",
}
